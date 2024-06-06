import 'package:shopping_helper/core/utils/codable.dart';

class ShoppingListItem extends Codable {
  final String title;

  ShoppingListItem({
    super.id,
    required this.title,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      ShoppingListItem(
        id: json.containsKey('id') ? json['id'] : null,
        title: json.containsKey('title') ? json['title'] : null,
      );

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll({'title': title});
  }
}
