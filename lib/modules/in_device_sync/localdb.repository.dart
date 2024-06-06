import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shopping_helper/core/utils/codable.dart';

enum LocalDatabaseStore { item, list }

class LocalDatabaseRepository {
  static const _dbFilename = 'app.db';
  Database? _db;

  Database get db {
    if (_db != null) {
      return _db!;
    } else {
      throw Exception('DB not loaded!');
    }
  }

  StoreRef<String, Map<String, Object?>> getStore(String name) =>
      stringMapStoreFactory.store(name);

  Future<Database> load() async {
    DatabaseFactory dbFactory = databaseFactoryIo;
    final appDir = await getApplicationDocumentsDirectory();
    appDir.create(recursive: true);
    final String dbFullPath = '${appDir.path}/$_dbFilename';
    _db = await dbFactory.openDatabase(dbFullPath);
    debugPrint('LocalDbRepository: DB loaded!');
    return _db!;
  }

  Future<void> dispose() async => await _db?.close();

  Future<Map<String, dynamic>> readId({
    required LocalDatabaseStore store,
    required String id,
  }) async {
    final dbStore = getStore(store.name);
    final record = await dbStore.record(id).get(db);
    if (record != null) {
      return record;
    } else {
      throw Exception('Cant find record!');
    }
  }

  Future<bool> saveId({
    required LocalDatabaseStore store,
    required Codable item,
  }) async {
    final dbStore = stringMapStoreFactory.store(store.name);
    await dbStore.record(item.id).put(db, item.toJson());
    return true;
  }

  Future<bool> deleteId({
    required LocalDatabaseStore store,
    required String id,
  }) async {
    final dbStore = getStore(store.name);
    return (await dbStore.record(id).delete(db)) != null;
  }

  Future<List<RecordSnapshot<String, Map<String, Object?>>>> readStore({
    required LocalDatabaseStore store,
  }) async {
    final records = await getStore(store.name).find(db);
    for (final record in records) {
      debugPrint('Record found: ${record.key}');
    }
    return records;
  }
}
