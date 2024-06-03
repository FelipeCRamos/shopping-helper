import 'package:uuid/v4.dart';

import 'unit_type.model.dart';

class ItemListItem {
  final String id;
  final String title;
  final double quantity;
  final UnitType unitType;
  final String? attentionPoints;
  final bool pickedUp;

  final double? currentUnitPrice;
  final bool? fixedPrice;
  double? get calculatedPrice {
    if(fixedPrice ?? false) {
      return currentUnitPrice;
    } else if (currentUnitPrice != null) {
      return currentUnitPrice! * quantity;
    }
    return null;
  }

  // later down the road: images

  // getters for showing appropriate values
  String get quantityWithUnit {
    if (!unitType.isDouble) {
      return '${quantity.round()} ${unitType.asString}';
    } else {
      return '${quantity.toStringAsFixed(2)}${unitType.asString}';
    }
  }

  ItemListItem({
    String? id,
    required this.title,
    this.quantity = 1,
    this.unitType = UnitType.unit,
    this.attentionPoints,
    this.pickedUp = false,
    this.currentUnitPrice,
    this.fixedPrice,
  }) : id = id ?? const UuidV4().generate();

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
}
