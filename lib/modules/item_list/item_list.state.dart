import 'package:shopping_helper/modules/item_list/models/item_list_item.model.dart';

class ItemListState {
  // flags
  final bool isLoading;
  final bool editModeEnabled;

  // data
  final String? title;
  final List<ItemListItem>? items;

  // aggregator
  double? get itemsSum {
    if (items?.isNotEmpty ?? false) {
      double sum = items!.fold(
        0.00,
        (currentSum, nextItem) {
          if (nextItem.pickedUp && nextItem.currentUnitPrice != null) {
            if (nextItem.fixedPrice ?? false) {
              currentSum += nextItem.currentUnitPrice!;
            } else {
              currentSum += nextItem.currentUnitPrice! * nextItem.quantity;
            }
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
    this.editModeEnabled = false,
    this.title,
    this.items,
  });
}
