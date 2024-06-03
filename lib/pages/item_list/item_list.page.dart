import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_helper/modules/item_list/item_list.cubit.dart';

import 'item_list.view.dart';

class ItemListPage extends StatelessWidget {
  const ItemListPage({
    super.key,
    required this.title,
    required this.listId,
  });

  final String title;
  final String listId;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (BuildContext context) => ItemListCubit(title: title)
        ..loadItems(
          listId: listId,
        ),
      child: const ItemListView(),
    );
  }
}
