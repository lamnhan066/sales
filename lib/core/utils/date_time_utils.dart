/// Utils
class DateTimeUtils {
  /// DateTime -> hh:mm h dd/MM/yyyy
  static String formatDateTime(DateTime date) {
    String padLeft2(int number) {
      return '$number'.padLeft(2, '0');
    }

    final hour = padLeft2(date.hour);
    final minute = padLeft2(date.minute);
    final day = padLeft2(date.day);
    final month = padLeft2(date.month);

    return '${hour}h$minute $day/$month/${date.year}';
  }

  /// DateTime -> d/M/yyyy
  static String dateToSql(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
