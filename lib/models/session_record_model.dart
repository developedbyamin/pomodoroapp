
class FocusSessionRecord {
  final int focusedSeconds;
  final DateTime date;

  FocusSessionRecord({
    required this.focusedSeconds,
    required this.date,
  });

  @override
  String toString() {
    return 'FocusSessionRecord(focusedSeconds: $focusedSeconds, date: $date)';
  }
}
