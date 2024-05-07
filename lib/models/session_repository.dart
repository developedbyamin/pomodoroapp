import 'package:shared_preferences/shared_preferences.dart';
import 'session_record_model.dart';

class FocusSessionRepository {
  static const String _sessionKey = 'focus_sessions';

  // Method to save the focus session record
  Future<void> saveFocusSession(int focusedSeconds, DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve existing session records from shared preferences
    List<String>? sessionStrings = prefs.getStringList(_sessionKey);

    // Convert existing session records from strings to objects
    List<FocusSessionRecord> sessionRecords = sessionStrings?.map((str) {
      List<String> parts = str.split(',');
      return FocusSessionRecord(
        focusedSeconds: int.parse(parts[0]),
        date: DateTime.parse(parts[1]),
      );
    }).toList() ?? [];

    // Add the new session record
    sessionRecords.add(FocusSessionRecord(
      focusedSeconds: focusedSeconds,
      date: date,
    ));

    // Convert session records to strings
    List<String> updatedSessionStrings = sessionRecords.map((record) {
      return '${record.focusedSeconds},${record.date.toIso8601String()}';
    }).toList();

    // Save updated session records to shared preferences
    await prefs.setStringList(_sessionKey, updatedSessionStrings);
  }

  // Method to retrieve all focus session records
  Future<List<FocusSessionRecord>> getAllFocusSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve session records from shared preferences
    List<String>? sessionStrings = prefs.getStringList(_sessionKey);

    // Convert session records from strings to objects
    List<FocusSessionRecord> sessionRecords = sessionStrings?.map((str) {
      List<String> parts = str.split(',');
      return FocusSessionRecord(
        focusedSeconds: int.parse(parts[0]),
        date: DateTime.parse(parts[1]),
      );
    }).toList() ?? [];

    return sessionRecords;
  }

  // Method to delete all focus session records
  Future<void> deleteAllFocusSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear all session records from shared preferences
    await prefs.remove(_sessionKey);
  }

  // Method to calculate daily focused time
  Future<Map<DateTime, int>> calculateDailyFocusedTime() async {
    List<FocusSessionRecord> records = await getAllFocusSessions();
    Map<DateTime, int> dailyFocused = {};

    for (var record in records) {
      DateTime date = DateTime(record.date.year, record.date.month, record.date.day);
      if (!dailyFocused.containsKey(date)) {
        dailyFocused[date] = 0;
      }
      dailyFocused[date] = dailyFocused[date]! + record.focusedSeconds;
    }

    return dailyFocused;
  }


  Future<Map<String, List<FocusSessionRecord>>> getLast7DaysFocusSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve session records from shared preferences
    List<String>? sessionStrings = prefs.getStringList(_sessionKey);

    // Convert session records from strings to objects
    List<FocusSessionRecord> sessionRecords = sessionStrings?.map((str) {
      List<String> parts = str.split(',');
      return FocusSessionRecord(
        focusedSeconds: int.parse(parts[0]),
        date: DateTime.parse(parts[1]),
      );
    }).toList() ?? [];

    // Group session records by day of the week
    Map<String, List<FocusSessionRecord>> last7DaysSessions = {
      'Mon': [],
      'Tue': [],
      'Wed': [],
      'Thu': [],
      'Fri': [],
      'Sat': [],
      'Sun': [],
    };

    // Get the current date and time
    DateTime now = DateTime.now();

    // Calculate the date 7 days ago
    DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Iterate through session records and categorize them by day of the week
    for (var record in sessionRecords) {
      if (record.date.isAfter(sevenDaysAgo) && record.date.isBefore(now)) {
        String dayAbbreviation = _getDayAbbreviation(record.date.weekday);
        last7DaysSessions[dayAbbreviation]?.add(record);
      }
    }

    return last7DaysSessions;
  }

  String _getDayAbbreviation(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

}
