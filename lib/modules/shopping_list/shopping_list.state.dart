import 'models/shopping_list_item.model.dart';

class ShoppingListState {
  // flags
  final bool isLoading;
  final bool editModeEnabled;

  // data to show
  final List<ShoppingListItem>? items;

  const ShoppingListState({
    this.isLoading = false,
    this.editModeEnabled = false,
    this.items,
  });
}
