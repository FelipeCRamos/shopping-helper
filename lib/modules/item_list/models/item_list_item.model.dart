import 'package:shopping_helper/core/utils/codable.dart';

import 'unit_type.model.dart';

class ItemListItem extends Codable {
  final String title;
  final double quantity;
  final UnitType unitType;
  final String? attentionPoints;
  final bool pickedUp;

  final double? currentUnitPrice;
  final bool? fixedPrice;

  // later down the road: images

  // getters for showing appropriate values
  double? get calculatedPrice {
    if (fixedPrice ?? false) {
      return currentUnitPrice;
    } else if (currentUnitPrice != null) {
      return currentUnitPrice! * quantity;
    }
    return null;
  }

  String get prettyPrint => "Item{title: '$title', quantity: '$quantity', "
      "unitType: '${unitType.name}', pickedUp: '$pickedUp', "
      "attentionPoints: '$attentionPoints'}";

  String get quantityAsString => unitType.isDouble
      ? quantity.toStringAsFixed(2)
      : quantity.round().toString();

  String get prettyQuantityWithUnit => unitType.isDouble
      ? '$quantityAsString${unitType.asString}'
      : '$quantityAsString ${unitType.asString}';

  ItemListItem({
    super.id,
    required this.title,
    this.quantity = 1,
    this.unitType = UnitType.unit,
    this.attentionPoints,
    this.pickedUp = false,
    this.currentUnitPrice,
    this.fixedPrice,
  });

  factory ItemListItem.fromJson(Map<String, dynamic> json) => ItemListItem(
        id: json.containsKey('id') ? json['id'] : null,
        title: json.containsKey('title') ? json['title'] : null,
        quantity: json.containsKey('quantity') ? json['quantity'] : null,
        unitType: UnitType.fromName(json['unitType']),
        attentionPoints: json.containsKey('attentionPoints')
            ? json['attentionPoints']
            : null,
        pickedUp: json.containsKey('pickedUp') ? json['pickedUp'] : null,
        currentUnitPrice: json.containsKey('currentUnitPrice')
            ? json['currentUnitPrice']
            : null,
        fixedPrice: json.containsKey('fixedPrice') ? json['fixedPrice'] : null,
      );

  ItemListItem copyWith({
    String? id,
    String? title,
    double? quantity,
    UnitType? unitType,
    String? attentionPoints,
    bool? pickedUp,
    double? currentUnitPrice,
    bool? fixedPrice,
  }) =>
      ItemListItem(
        id: id ?? this.id,
        title: title ?? this.title,
        quantity: quantity ?? this.quantity,
        unitType: unitType ?? this.unitType,
        attentionPoints: attentionPoints ?? this.attentionPoints,
        pickedUp: pickedUp ?? this.pickedUp,
        currentUnitPrice: currentUnitPrice ?? this.currentUnitPrice,
        fixedPrice: fixedPrice ?? this.fixedPrice,
      );

  @override
  Map<String, dynamic> toJson() {
    return super.toJson()..addAll(
      {
        'title': title,
        'quantity': quantity,
        'unitType': unitType.toJson,
        'attentionPoints': attentionPoints,
        'pickedUp': pickedUp,
        'currentUnitPrice': currentUnitPrice,
        'fixedPrice': fixedPrice,
      },
    );
  }
}
