import 'package:intl/intl.dart';

String formatDateTime(DateTime date) {
  return DateFormat.yMMMd().format(date);
}
