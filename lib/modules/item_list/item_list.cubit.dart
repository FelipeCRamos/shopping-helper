import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_helper/core/extensions/list.extension.dart';

import 'item_list.state.dart';
import 'models/item_list_item.model.dart';
import 'models/unit_type.model.dart';

class ItemListCubit extends Cubit<ItemListState> {
  ItemListCubit({required this.title}) : super(const ItemListState());

  final String title;
  List<ItemListItem>? items;

  Future<void> loadItems({
    required String listId,
  }) async {
    emit(const ItemListState(isLoading: true));

    // ... processes ... //

    items = [
      ItemListItem(title: 'Abacaxi'),
      ItemListItem(title: 'Atum'),
      ItemListItem(title: 'Banana', unitType: UnitType.kilograms, quantity: 1),
      ItemListItem(
        title: 'Bicarbonato de Sódio',
        unitType: UnitType.grams,
        quantity: 200,
      ),
      ItemListItem(title: 'Guaraná Latinha 270ml', quantity: 4),
      ItemListItem(title: 'Sprite', quantity: 2, unitType: UnitType.liter),
      ItemListItem(title: 'Agua de Coco', unitType: UnitType.liter, quantity: 2)
    ];

    emit(ItemListState(isLoading: false, items: items, title: title));
  }

  void toggleEditMode() {
    emit(
      ItemListState(
        items: items,
        title: title,
        editModeEnabled: !state.editModeEnabled,
      ),
    );
  }

  Future<void> togglePickedUp(String id) async {
    emit(
      ItemListState(
        isLoading: true,
        title: title,
        items: items,
        editModeEnabled: state.editModeEnabled,
      ),
    );
    items?.replaceWhere(
      predicate: (item) => item.id == id,
      createObject: (item) => item.copyWith(pickedUp: !item.pickedUp),
    );
    emit(
      ItemListState(
        isLoading: false,
        title: title,
        items: items,
        editModeEnabled: state.editModeEnabled,
      ),
    );
  }

  Future<void> removeFromList(String id) async {
    final editModeEnabled = state.editModeEnabled;
    emit(
      ItemListState(
        isLoading: true,
        title: title,
        items: items,
        editModeEnabled: editModeEnabled,
      ),
    );
    items?.removeWhere((item) => item.id == id);
    emit(
      ItemListState(
        isLoading: false,
        items: items,
        title: title,
        editModeEnabled: editModeEnabled,
      ),
    );
  }

  Future<void> editItem(
    String id,
    ItemListItem Function(ItemListItem) change,
  ) async {
    emit(
      ItemListState(
        isLoading: true,
        items: items,
        title: title,
        editModeEnabled: state.editModeEnabled,
      ),
    );

    items?.replaceWhere(
      predicate: (item) => item.id == id,
      createObject: (oldItem) {
        final newItem = change(oldItem);
        if (_validateItem(newItem)) {
          debugPrint('Changing to new item:\n-> ${newItem.prettyPrint}');
          return change(newItem);
        } else {
          debugPrint('New item not validated, reverting changes!');
          return oldItem;
        }
      },
    );

    emit(
      ItemListState(
        isLoading: false,
        items: items,
        title: title,
        editModeEnabled: state.editModeEnabled,
      ),
    );
  }

  bool _validateItem(ItemListItem item) {
    // TODO: Create validations
    return true;
  }

  Future<void> addItem(ItemListItem item) async {
    emit(ItemListState(isLoading: true, items: items, title: title));
    if(_validateItem(item)) {
      items?.add(item);
    } else {
      throw Exception('Item is not valid');
    }
    emit(ItemListState(isLoading: false, items: items, title: title));
  }
}
