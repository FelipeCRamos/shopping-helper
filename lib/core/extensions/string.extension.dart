import 'package:intl/intl.dart';

extension DoubleParser on String {
  double fromMoneyToDouble() {
    // final parsedDouble = NumberFormat().parse(this);
    String cleanedString;

    if((!contains('.') && split(',').length <= 2) || !(contains('.') || contains(','))) {
      // good to go
      cleanedString = this;
    } else if(contains('.') && contains(',')) {
      // bad format
      throw Exception('Bad format');
    } else if (contains('.') && split('.').length <= 2){
      // inside the error zone, but recoverable
      cleanedString = replaceAll('.', ',');
    } else {
      throw Exception('Not valid');
    } 
    
    final parsedDouble = NumberFormat.currency(locale: 'pt_BR').parse(cleanedString);
    return parsedDouble.toDouble();
  }
}
