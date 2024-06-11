class DateUtills {
  static DateTime getStartOfWeek(DateTime date) {
    int weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  static DateTime getEndOfWeek(DateTime date) {
    int weekday = date.weekday;
    return date.add(Duration(days: 7 - weekday));
  }
}
