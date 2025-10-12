import 'package:intl/intl.dart';

String thounsandSeparator(num value) {
  final formatter = NumberFormat('#,###');
  return formatter.format(value);
}
