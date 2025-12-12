// lib/utils/date_formatter.dart

import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
class DateFormatter {
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, MMM d').format(date);
  }

  static String formatTime(DateTime date, {bool is24Hour = true}) {
    if (is24Hour) {
      return DateFormat('HH:mm').format(date); // 24h: 13:00
    } else {
      return DateFormat('h:mm a').format(date); // 12h: 1:00 PM
    }
  }

  static String formatDay(DateTime date) {
    return DateFormat('EEEE').format(date);
  }
  
  static String formatDateTime(DateTime date) {
    return DateFormat('MMM d, h:mm a').format(date);
  }
}