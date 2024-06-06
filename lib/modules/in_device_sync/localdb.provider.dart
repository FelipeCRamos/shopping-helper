import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_helper/modules/in_device_sync/localdb.repository.dart';

class LocalDatabaseProvider extends StatelessWidget {
  const LocalDatabaseProvider({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final localDb = LocalDatabaseRepository();

    return FutureBuilder(
      future: localDb.load(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          return Provider(
            create: (ctx) => localDb,
            dispose: (ctx, repository) => repository.dispose(),
            child: child,
          );
        }
      },
    );
  }
}
