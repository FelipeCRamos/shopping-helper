import 'package:shopping_helper/core/utils/codable.dart';

class ShoppingListItem with Codable {
  final String title;

  ShoppingListItem({
    required this.title,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      ShoppingListItem(
        title: json.containsKey('title') ? json['title'] : null,
      );

  @override
  Map<String, dynamic> toJson() {
    return {'title': title};
  }
}
