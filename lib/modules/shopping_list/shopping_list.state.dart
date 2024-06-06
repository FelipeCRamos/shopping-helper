import 'models/shopping_list_item.model.dart';

class ShoppingListState {
  // flags
  final bool isLoading;
  final bool isEditing;

  // data to show
  final List<ShoppingListItem>? items;

  const ShoppingListState({
    this.isLoading = false,
    this.isEditing = false,
    this.items,
  });
}
