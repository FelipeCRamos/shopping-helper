import 'package:sembast/sembast.dart';
import 'package:shopping_helper/modules/in_device_sync/localdb.repository.dart';
import 'package:shopping_helper/modules/item_list/models/item_list_item.model.dart';

extension ItemListRepository on LocalDatabaseRepository {
  Future<bool> saveItem(ItemListItem item) async {
    return await saveId(store: LocalDatabaseStore.item, item: item);
  }

  Future<bool> removeItem(String id) async {
    return await deleteId(store: LocalDatabaseStore.item, id: id);
  }

  Future<ItemListItem> getItemById(String id) async {
    final record = await readId(store: LocalDatabaseStore.item, id: id);
    return ItemListItem.fromJson(record);
  }

  Future<List<ItemListItem>> getItemsFromList(String shoppingListId) async {
    final records = await readStore(
      store: LocalDatabaseStore.item,
      finder: Finder(
        filter: Filter.equals('parentShoppingListId', shoppingListId),
      ),
    );
    return records
        .map((record) => ItemListItem.fromJson(record.value))
        .toList();
  }
}
