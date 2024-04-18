import 'package:intl/intl.dart';

String formatNumberWithCommas(double number) {
  final formatter = NumberFormat("#,##0", "en_US");
  return formatter.format(number);
}