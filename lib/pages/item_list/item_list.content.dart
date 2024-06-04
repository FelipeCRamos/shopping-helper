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
                            child: ItemAddPriceView(
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
                          ),
                        );
                      },
                    );
                  },
                  onRemove: () {
                    debugPrint('Removing item "${item.title}" from list...');
                    cubit.removeFromList(item.id);
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
