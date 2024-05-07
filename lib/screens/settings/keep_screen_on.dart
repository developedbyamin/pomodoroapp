import 'package:flutter/material.dart';
import 'package:pomodoro/screens/settings/settings_controller.dart';
import 'package:provider/provider.dart';

import '../../utils/constants/sizes.dart';

class KeepScreenOnSwitch extends StatefulWidget {
  const KeepScreenOnSwitch({super.key});

  @override
  State<KeepScreenOnSwitch> createState() => _KeepScreenOnSwitchState();
}

class _KeepScreenOnSwitchState extends State<KeepScreenOnSwitch> {

  @override
  Widget build(BuildContext context) {
    var screenTimeoutState = Provider.of<SettingsController>(context);
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
              Text('Keep screen awake', style: textTheme.titleLarge!.copyWith(color: Colors.white),),
              Text('Enable to keep the timer screen always on',  style: textTheme.labelSmall!.copyWith(color: Colors.white),),
            ],
          ),
          Switch(
            value: screenTimeoutState.isAlwaysOn,
            onChanged: (value) => screenTimeoutState.setAlwaysOn(value),
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
