import 'package:shared_preferences/shared_preferences.dart';
import '../models/session_record_model.dart';

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


  Future<List<String>> getLast7DaysNames() async {
    DateTime now = DateTime.now();
    List<String> daysNames = [];

    for (int i = 0; i < 7; i++) {
      DateTime day = now.subtract(Duration(days: i));
      daysNames.add(_getDayAbbreviation(day.weekday));
    }

    return daysNames.reversed.toList();
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