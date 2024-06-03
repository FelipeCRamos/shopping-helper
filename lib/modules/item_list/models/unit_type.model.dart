enum UnitType {
  grams('g', isDouble: false),
  kilograms('kg', isDouble: false),
  unit('un.', isDouble: false),
  milliliter('mL', isDouble: false),
  liter('L', isDouble: false);

  const UnitType(this.asString, {this.isDouble = true});

  final String asString;
  final bool isDouble;
}
