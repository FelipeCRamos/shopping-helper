import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopping_helper/modules/shopping_list/shopping_list.cubit.dart';
import 'package:shopping_helper/modules/shopping_list/shopping_list.state.dart';

import 'components/shopping_list_item.component.dart';

class ShoppingListContent extends StatelessWidget {
  const ShoppingListContent({super.key, required this.state});

  final ShoppingListState state;

  @override
  Widget build(BuildContext context) {

    final cubit = context.read<ShoppingListCubit>();

    return Scaffold(
      body: ListView(
        children: state.items!
            .map(
              (listItem) => ShoppingListItem(
                id: listItem.id,
                title: listItem.title,
                editMode: state.editModeEnabled,
                onTap: () {
                  debugPrint('Performing navigation to "${listItem.title}" list...');
                  context.go(
                    '/shoppingLists/${listItem.id}',
                    extra: listItem.title,
                  );
                },
                onLongTap: () {
                  debugPrint('Changing to edit mode b/c of long tapping...');
                  cubit.toggleEditMode();
                },
                onRemoveTap: () => cubit.removeFromList(listItem.id),
              ),
            )
            .toList(),
      ),
    );
  }
}
