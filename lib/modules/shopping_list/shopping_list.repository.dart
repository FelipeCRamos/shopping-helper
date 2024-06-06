import 'package:shopping_helper/modules/in_device_sync/localdb.repository.dart';
import 'package:shopping_helper/modules/shopping_list/models/shopping_list_item.model.dart';

extension ShoppingListRepository on LocalDatabaseRepository {
  Future<bool> saveShoppingList(ShoppingListItem list) async {
    return await saveId(store: LocalDatabaseStore.list, item: list);
  }
  Future<bool> removeShoppingList(String id) async {
    return await deleteId(store: LocalDatabaseStore.list, id: id);
  }

  Future<ShoppingListItem> getShoppingList(String id) async {
    final record = await readId(store: LocalDatabaseStore.list, id: id);
    return ShoppingListItem.fromJson(record);
  }

  Future<List<ShoppingListItem>> getShoppingLists() async {
    final records = await readStore(store: LocalDatabaseStore.list);
    return records
        .map((record) => ShoppingListItem.fromJson(record.value))
        .toList();
  }

}
