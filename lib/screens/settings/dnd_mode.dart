import 'package:flutter/material.dart';
import 'package:flutter_dnd/flutter_dnd.dart';
import '../../utils/constants/sizes.dart';

class DnDMode extends StatefulWidget {
  const DnDMode({super.key});

  @override
  State<DnDMode> createState() => _DnDModeState();
}

class _DnDModeState extends State<DnDMode> {
  bool isDNDActive = false;

  @override
  void initState() {
    super.initState();
    _checkDNDStatus();
  }

  Future<void> _checkDNDStatus() async {
    final dndStatus = await FlutterDnd.getCurrentInterruptionFilter();
    setState(() {
      isDNDActive = dndStatus == FlutterDnd.INTERRUPTION_FILTER_NONE;
    });
  }

  Future<void> _toggleDNDMode() async {
    try {
      if (isDNDActive) {
        await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_ALL);
      } else {
        await FlutterDnd.setInterruptionFilter(FlutterDnd.INTERRUPTION_FILTER_NONE);
      }
      setState(() {
        isDNDActive = !isDNDActive;
      });
    } catch (e) {
      print('Failed to toggle DND mode: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1),
      ),
      padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DND mode',
                style: textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
              Text(
                'Activate/Deactivate Do Not Disturb mode',
                style: textTheme.labelSmall!.copyWith(color: Colors.white),
              ),
            ],
          ),
          Switch(
            value: isDNDActive,
            onChanged: (value) {
              _toggleDNDMode();
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
