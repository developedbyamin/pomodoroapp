import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../settings_controller.dart';

class ThemeChanger extends StatelessWidget {
  const ThemeChanger({super.key, required this.gradientColors,});

  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<SettingsController>(context, listen: false).selectedGradient = gradientColors;
      },
      child: Consumer<SettingsController>(
        builder: (context, colorSelectionModel, child) {
          final isSelected = colorSelectionModel.selectedGradient == gradientColors;
          return Container(
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
          );
        },
      ),
    );
  }
}
