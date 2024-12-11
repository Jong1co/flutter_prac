import 'package:intl/intl.dart';

class DateTools {
  static String format(DateTime date, [String newPattern = 'yyyy-MM-dd']) {
    return DateFormat(newPattern).format(date);
  }

  static DateTime parse(String date) {
    final RegExp datePattern = RegExp(r'(\d{4})[-./](\d{1,2})[-./](\d{1,2})');
    final Match? match = datePattern.firstMatch(date);

    if (match != null) {
      final int year = int.parse(match.group(1)!);
      final int month = int.parse(match.group(2)!);
      final int day = int.parse(match.group(3)!);

      return DateTime(year, month, day);
    } else {
      throw Exception('날짜 형식이 올바르지 않습니다.');
    }
  }
}
