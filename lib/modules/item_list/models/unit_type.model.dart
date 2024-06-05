enum UnitType {
  grams('g', isDouble: false),
  kilograms('kg', isDouble: false),
  unit('un.', isDouble: false),
  milliliter('mL', isDouble: false),
  liter('L', isDouble: false);

  const UnitType(this.asString, {this.isDouble = true});

  String get toJson => name;
  factory UnitType.fromName(String json) => UnitType.values.firstWhere(
        (element) => element.toJson == json,
      );

  final String asString;
  final bool isDouble;
}
