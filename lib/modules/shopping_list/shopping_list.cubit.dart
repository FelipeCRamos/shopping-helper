import 'package:bloc/bloc.dart';
import 'package:shopping_helper/modules/in_device_sync/localdb.repository.dart';
import 'package:shopping_helper/modules/shopping_list/shopping_list.repository.dart';

import 'models/shopping_list_item.model.dart';
import 'shopping_list.state.dart';

class ShoppingListCubit extends Cubit<ShoppingListState> {
  ShoppingListCubit({required LocalDatabaseRepository repository})
      : _repository = repository,
        super(const ShoppingListState());

  final LocalDatabaseRepository _repository;
  List<ShoppingListItem>? items;

  Future<void> loadItems() async {
    emit(const ShoppingListState(isLoading: true));

    {
      items = await _repository.getShoppingLists();
    }

    emit(ShoppingListState(isLoading: false, items: items));
  }

  void toggleEditMode() {
    emit(ShoppingListState(items: items, isEditing: !state.isEditing));
  }

  Future<void> removeFromList(String id) async {
    final isEditing = state.isEditing;
    emit(const ShoppingListState(isLoading: true));

    {
      if (await _repository.removeShoppingList(id)) {
        items?.removeWhere((item) => item.id == id);
      }
    }

    emit(ShoppingListState(items: items, isEditing: isEditing));
  }

  Future<void> addList(String name) async {
    emit(const ShoppingListState(isLoading: true));

    {
      final newList = ShoppingListItem(title: name);
      await _repository.saveShoppingList(newList);
      items?.add(newList);
    }

    emit(ShoppingListState(items: items));
  }
}
