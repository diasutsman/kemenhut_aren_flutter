import 'package:intl/intl.dart';

String currencyFormatter(double value, String? currency,
    {int decimalDigit = 2,}) {
  final formatter = _currencyToNumberFormat(
    currency,
    currency == 'IDR' ? 0 : decimalDigit,
  );

  return formatter.format(value);
}

NumberFormat _currencyToNumberFormat(String? currency, int decimalDigit) {
  return NumberFormat.simpleCurrency(
    name: currency,
    decimalDigits: decimalDigit,
  );
}
