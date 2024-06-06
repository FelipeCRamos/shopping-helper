import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_helper/modules/item_list/item_list.cubit.dart';
import 'package:shopping_helper/modules/item_list/item_list.state.dart';
import 'package:shopping_helper/modules/item_list/models/item_list_item.model.dart';
import 'package:shopping_helper/pages/item_list/item_edit.view.dart';
import 'package:shopping_helper/pages/item_list/item_list_summup.content.dart';
import 'package:shopping_helper/pages/shared/components/list_content_empty.component.dart';
import 'package:shopping_helper/pages/shared/components/list_content_loading.component.dart';

import 'item_list.content.dart';

class ItemListView extends StatelessWidget {
  const ItemListView({super.key, required this.listId});

  final String listId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListCubit, ItemListState>(
      builder: (context, state) {
        final cubit = context.read<ItemListCubit>();
        Widget body;

        if (state.isLoading) {
          body = const ListContentLoading();
        } else if (state.items?.isNotEmpty ?? false) {
          body = ItemListContent(state: state);
        } else {
          body = const ListContentEmpty();
        }

        final double? bagSum = state.itemsSum;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              state.title ?? '...',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_backup_restore),
                onPressed: () => cubit.resetListPrices(listId: listId),
              ),
            ],
          ),
          body: body,
          floatingActionButton: FloatingActionButton(
            // label: const Text('Adicionar item'),
            child: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) {
                  return SizedBox(
                    width: MediaQuery.of(ctx).size.width,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(ctx).viewInsets.bottom,
                      ),
                      child: ItemEditView(
                        currentItem: ItemListItem(
                          title: '',
                          parentShoppingListId: listId,
                        ),
                        isAdding: true,
                        onSubmitted: (item) {
                          cubit.addItem(item);
                          // TODO: return actual result
                          return true;
                        },
                      ),
                    ),
                  );
                },
              );
              // context.read<ItemListCubit>().addItem()
            },
          ),
          bottomSheet: ItemListSummupContent(
            key: const Key('item-list-summup'),
            shouldAppear: bagSum != null,
            calculatedBagValue: bagSum,
          ),
        );
      },
    );
  }
}
