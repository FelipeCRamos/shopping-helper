import 'package:shopping_helper/modules/item_list/models/item_list_item.model.dart';

class ItemListState {
  // flags
  final bool isLoading;
  final bool editModeEnabled;

  // data
  final String? title;
  final List<ItemListItem>? items;

  const ItemListState({
    this.isLoading = false,
    this.editModeEnabled = false,
    this.title,
    this.items,
  });
}
