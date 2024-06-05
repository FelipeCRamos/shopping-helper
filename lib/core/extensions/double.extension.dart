import 'package:intl/intl.dart';

extension MoneyFormat on double {
  String toMoneyString({bool withMoneySymbol = true}) =>
      NumberFormat.simpleCurrency(
        decimalDigits: 2,
        locale: 'pt_BR',
        name: withMoneySymbol ? 'R\$' : '',
      ).format(this).trimLeft();
}
