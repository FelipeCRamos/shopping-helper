import 'package:bloc/bloc.dart';
import 'package:shopping_helper/modules/in_device_sync/localdb.repository.dart';

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
    // ... processes ... //

    await _repository.load();

    items = [
      ShoppingListItem(title: 'Lista principal'),
      ShoppingListItem(title: 'Lista para festas pequenas'),
      ShoppingListItem(title: 'Lista emergencial para economizar'),
    ];

    emit(ShoppingListState(isLoading: false, items: items));
  }

  void toggleEditMode() {
    emit(ShoppingListState(
        items: items, editModeEnabled: !state.editModeEnabled));
  }

  Future<void> removeFromList(String id) async {
    final editModeEnabled = state.editModeEnabled;
    emit(ShoppingListState(isLoading: true, editModeEnabled: editModeEnabled));
    items?.removeWhere((item) => item.id == id);
    emit(ShoppingListState(
        isLoading: false, items: items, editModeEnabled: editModeEnabled));
  }

  Future<void> addList(String name) async {
    emit(const ShoppingListState(isLoading: true));
    items?.add(ShoppingListItem(title: name));
    emit(ShoppingListState(isLoading: false, items: items));
  }
}
