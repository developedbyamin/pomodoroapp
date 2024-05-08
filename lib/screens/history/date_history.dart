import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/session_record_model.dart';
import '../../repository/session_repository.dart';
import '../../utils/constants/sizes.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final FocusSessionRepository repository = FocusSessionRepository();
  late List<FocusSessionRecord> sessionRecords = [];
  late Map<DateTime, int> dailyFocusedTime = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadSessionRecords();
  }

  Future<void> loadSessionRecords() async {
    setState(() {
      _isLoading = true; // Set isLoading to true when loading starts
    });
    List<FocusSessionRecord> records = await repository.getAllFocusSessions();
    Map<DateTime, int> focusedTime =
        await repository.calculateDailyFocusedTime();
    setState(() {
      sessionRecords = records;
      dailyFocusedTime = focusedTime;
      _isLoading = false; // Set isLoading to false after loading completes
    });
  }

  String formatFocusedTime(int totalFocusedTime) {
    int hours = totalFocusedTime ~/ 3600;
    int minutes = (totalFocusedTime % 3600) ~/ 60;
    int seconds = totalFocusedTime % 60;

    String formattedTime = '';
    if (hours > 0) {
      formattedTime += '$hours hours ';
    }
    if (minutes > 0) {
      formattedTime += '$minutes minutes ';
    }
    if (seconds > 0) {
      formattedTime += '$seconds seconds';
    }
    return formattedTime;
  }

  Widget _buildButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.transparent,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: () async {
          // Delete all records
          await FocusSessionRepository().deleteAllFocusSessions();
          // Reload session records after deletion
          await loadSessionRecords();
        },
        icon: const Icon(Icons.delete_outline, size: 32, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
        child: Stack(
          children: [
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : sessionRecords.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: false,
                        itemCount: dailyFocusedTime.length,
                        itemBuilder: (context, index) {
                          DateTime currentDate =
                              dailyFocusedTime.keys.toList()[index];
                          int totalFocusedTime = dailyFocusedTime[currentDate]!;
                          String formattedDate =
                              DateFormat.MMMMd().format(currentDate);

                          return Container(
                            padding: const EdgeInsets.all(
                                PomodoroAppSizes.spaceBtwItems),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                            margin: const EdgeInsets.only(
                                bottom: PomodoroAppSizes.spaceBtwItems),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Focused time: ${formatFocusedTime(totalFocusedTime)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "No records found.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _buildButton(),
            ),
          ],
        ),
      ),
    );
  }
}
