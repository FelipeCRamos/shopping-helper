import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_helper/modules/item_list/item_list.cubit.dart';
import 'package:shopping_helper/modules/item_list/item_list.state.dart';
import 'package:shopping_helper/pages/item_list/item_list_summup.content.dart';
import 'package:shopping_helper/pages/shared/components/list_content_empty.component.dart';
import 'package:shopping_helper/pages/shared/components/list_content_loading.component.dart';

import 'item_list.content.dart';

class ItemListView extends StatelessWidget {
  const ItemListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemListCubit, ItemListState>(
      builder: (context, state) {
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
          ),
          body: body,
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
