import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_helper/modules/item_list/item_list.cubit.dart';
import 'package:shopping_helper/modules/item_list/item_list.state.dart';

import 'components/item_tile.component.dart';
import 'item_add_price.view.dart';

class ItemListContent extends StatelessWidget {
  const ItemListContent({super.key, required this.state});

  final ItemListState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ItemListCubit>();
    return ListView(
      padding: const EdgeInsets.only(
        left: 4,
        right: 4,
        top: 16,
        bottom: 16,
      ),
      children: state.items!
          .map(
            (item) => Column(
              children: [
                ItemTile(
                  key: Key('item-tile-${item.id}'),
                  item: item,
                  onTap: () => cubit.togglePickedUp(item.id),
                  onLongTap: () {
                    Scaffold.of(context).showBottomSheet(
                      (ctx) => ItemAddPriceView(
                        onSubmitted: (double price, bool checkboxTapped) {
                          if (price >= 0) {
                            cubit.addCurrentPrice(
                              item.id,
                              price,
                              isAbsolute: checkboxTapped,
                            );
                            return true;
                          }
                          return false;
                        },
                      ),
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                    );
                  },
                ),
                const Divider(thickness: 0.3, height: 0),
              ],
            ),
          )
          .toList(),
    );
  }
}
