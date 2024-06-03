import 'package:uuid/v4.dart';

class ShoppingListItem {
  final String id;
  final String title;

  ShoppingListItem({String? id, required this.title})
      : id = id ?? const UuidV4().generate();
}
