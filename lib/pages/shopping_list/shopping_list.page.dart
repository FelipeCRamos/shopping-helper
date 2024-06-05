import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_helper/modules/in_device_sync/localdb.repository.dart';
import 'package:shopping_helper/modules/shopping_list/shopping_list.cubit.dart';

import 'shopping_list.view.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (BuildContext context) => ShoppingListCubit(
        repository: context.read<LocalDatabaseRepository>(),
      )..loadItems(),
      child: const ShoppingListView(),
    );
  }
}
