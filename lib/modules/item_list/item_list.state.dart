import 'package:shopping_helper/modules/item_list/models/item_list_item.model.dart';

class ItemListState {
  // flags
  final bool isLoading;

  // data
  final String? title;
  final List<ItemListItem>? items;

  // aggregator
  double? get itemsSum {
    if (items?.isNotEmpty ?? false) {
      double sum = items!.fold(
        0.00,
        (currentSum, nextItem) {
          if (nextItem.pickedUp) {
            currentSum += nextItem.calculatedPrice ?? 0;
          }
          return currentSum;
        },
      );
      return sum;
    }

    return null;
  }

  const ItemListState({
    this.isLoading = false,
    this.title,
    this.items,
  });
}
