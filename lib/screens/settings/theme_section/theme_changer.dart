import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings_controller.dart';

class ThemeChanger extends StatelessWidget {
  const ThemeChanger({super.key, required this.gradientColors});

  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsController>(
      builder: (context, settingsController, _) {
        final isSelected = settingsController.selectedGradient == gradientColors;
        return GestureDetector(
          onTap: () {
            settingsController.selectedGradient = gradientColors;
          },
          child: Container(
            width: 50,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                width: 1,
                color: isSelected ? Colors.white : Colors.black,
              ),
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        );
      },
    );
  }
}
