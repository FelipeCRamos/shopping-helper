import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_helper/core/extensions/list.extension.dart';
import 'package:shopping_helper/modules/in_device_sync/localdb.repository.dart';
import 'package:shopping_helper/modules/item_list/item_list.repository.dart';

import 'item_list.state.dart';
import 'models/item_list_item.model.dart';

class ItemListCubit extends Cubit<ItemListState> {
  ItemListCubit({
    required this.title,
    required LocalDatabaseRepository repository,
  })  : _repository = repository,
        super(const ItemListState());

  final LocalDatabaseRepository _repository;
  final String title;
  List<ItemListItem>? items;

  Future<void> loadItems({
    required String listId,
  }) async {
    emit(const ItemListState(isLoading: true));

    {
      items = await _repository.getItemsFromList(listId);
    }

    emit(ItemListState(isLoading: false, items: items, title: title));
  }

  Future<void> resetListPrices({required String listId}) async {
    emit(const ItemListState(isLoading: true));

    {
      for (final item in items!) {
        final newItem = item.copyWith(currentUnitPrice: 0);
        editItem(newItem.id, (oldItem) => newItem);
      }
    }

    emit(ItemListState(items: items, title: title));
  }

  Future<void> togglePickedUp(String id) async {
    emit(
      ItemListState(
        isLoading: true,
        title: title,
        items: items,
      ),
    );
    {
      ItemListItem? newItem;
      items?.replaceWhere(
        predicate: (item) => item.id == id,
        createObject: (item) {
          newItem = item.copyWith(pickedUp: !item.pickedUp);
          return newItem!;
        },
      );
      if (newItem != null) {
        // updates the item, can be optimized later
        await _repository.removeItem(newItem!.id);
        await _repository.saveItem(newItem!);
      }
    }

    emit(
      ItemListState(
        isLoading: false,
        title: title,
        items: items,
      ),
    );
  }

  Future<void> removeFromList(String id) async {
    emit(
      ItemListState(
        isLoading: true,
        title: title,
        items: items,
      ),
    );

    {
      items?.removeWhere((item) => item.id == id);
      await _repository.removeItem(id);
    }

    emit(
      ItemListState(
        isLoading: false,
        items: items,
        title: title,
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
      ),
    );

    {
      ItemListItem? newItem;
      items?.replaceWhere(
        predicate: (item) => item.id == id,
        createObject: (oldItem) {
          newItem = change(oldItem);
          if (_validateItem(newItem!)) {
            debugPrint('Changing to new item:\n-> ${newItem?.prettyPrint}');
            return change(newItem!);
          } else {
            debugPrint('New item not validated, reverting changes!');
            newItem = null;
            return oldItem;
          }
        },
      );
      if (newItem != null) {
        await _repository.removeItem(newItem!.id);
        await _repository.saveItem(newItem!);
      }
    }

    emit(
      ItemListState(
        isLoading: false,
        items: items,
        title: title,
      ),
    );
  }

  bool _validateItem(ItemListItem item) {
    // TODO: Create validations
    return true;
  }

  Future<void> addItem(ItemListItem item) async {
    emit(ItemListState(isLoading: true, items: items, title: title));

    {
      if (_validateItem(item)) {
        items?.add(item);
        await _repository.saveItem(item);
      } else {
        throw Exception('Item is not valid');
      }
    }

    emit(ItemListState(isLoading: false, items: items, title: title));
  }
}
