import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_helper/core/router.dart';
import 'package:shopping_helper/modules/in_device_sync/localdb.provider.dart';
import 'package:shopping_helper/modules/in_device_sync/localdb.repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LocalDatabaseProvider(
      child: Builder(
        builder: (ctx) => MaterialApp.router(
          title: 'Shopping List Helper',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
            useMaterial3: true,
          ),
          routerConfig: mainRouter(ctx.read<LocalDatabaseRepository>()),
        ),
      ),
    );
  }
}
