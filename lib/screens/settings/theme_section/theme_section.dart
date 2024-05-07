import 'package:flutter/material.dart';
import 'package:pomodoro/screens/settings/theme_section/theme_changer.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';


class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 1),
      ),
      padding: const EdgeInsets.all(PomodoroAppSizes.spaceBtwItems),
      child: Column(
        children: [
          Text('Themes',style: textTheme.headlineLarge!.copyWith(color: Colors.white),),
          const SizedBox(height: PomodoroAppSizes.spaceBtwItems,),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ThemeChanger(gradientColors: PomodoroColors.gradientColors1),
              ThemeChanger(gradientColors: PomodoroColors.gradientColors2),
              ThemeChanger(gradientColors: PomodoroColors.gradientColors3),
              ThemeChanger(gradientColors: PomodoroColors.gradientColors4),
              ThemeChanger(gradientColors: PomodoroColors.gradientColors5),
            ],
          ),
          const SizedBox(height: PomodoroAppSizes.spaceBtwItems,),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ThemeChanger(gradientColors: PomodoroColors.gradientColors6),
              ThemeChanger(gradientColors: PomodoroColors.gradientColors7),
              ThemeChanger(gradientColors: PomodoroColors.gradientColors8),
              ThemeChanger(gradientColors: PomodoroColors.gradientColors9),
              ThemeChanger(gradientColors: PomodoroColors.gradientColors10),
            ],
          ),
        ],
      ),
    );
  }
}
