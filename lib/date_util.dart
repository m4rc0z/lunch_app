class DateUtil {
  static List<DateTime> getWeekDaysForDate(DateTime curr) {
    List<DateTime> week = [];

    for (var i = 1; i <= 7; i++) {
      var first = curr.day - curr.weekday + i;
      var day = DateTime.utc(curr.year, curr.month, first);
      week.add(day);
    }

    return week;
  }
}