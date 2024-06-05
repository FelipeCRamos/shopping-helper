import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shopping_helper/core/utils/codable.dart';

class LocalDatabaseProvider extends StatelessWidget {
  const LocalDatabaseProvider({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) => Provider(
        create: (ctx) => LocalDatabaseRepository(),
        dispose: (ctx, repository) => repository.dispose(),
        child: child,
      );
}

enum LocalDatabaseStore { item, list }

class LocalDatabaseRepository {
  static const dbFilename = 'app.db';
  Database? _db;

  // db functions
  Future<Database> load() async {
    DatabaseFactory dbFactory = databaseFactoryIo;
    final appDir = await getApplicationDocumentsDirectory();
    appDir.create(recursive: true);
    final String dbFullPath = '${appDir.path}/$dbFilename';
    _db = await dbFactory.openDatabase(dbFullPath);
    debugPrint('LocalDbRepository: DB loaded!');
    return _db!;
  }

  Future<void> dispose() async => await _db?.close();

  Database _ensureDbLoaded() {
    if (_db != null) {
      return _db!;
    } else {
      throw Exception('DB not loaded!');
    }
  }

  StoreRef<String, Map<String, Object?>> _getStore(String storeName) =>
      stringMapStoreFactory.store(storeName);

  Future<Map<String, dynamic>> readFromId({
    required LocalDatabaseStore store,
    required String id,
  }) async {
    final db = _ensureDbLoaded();
    final dbStore = _getStore(store.name);
    final record = await dbStore.record(id).get(db);
    if(record != null) {
      return record;
    } else {
      throw Exception('Cant find record!');
    }
  }

  Future<bool> saveToId({
    required LocalDatabaseStore store,
    required Codable item,
  }) async {
    final db = _ensureDbLoaded();
    final dbStore = stringMapStoreFactory.store(store.name);
    await dbStore.record(item.id).put(db, item.toJson());
    return true;
  }
}
