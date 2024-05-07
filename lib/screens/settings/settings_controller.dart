import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import '../../utils/constants/colors.dart';

class SettingsController extends ChangeNotifier {
  List<Color> _selectedGradient = PomodoroColors.gradientColors1; // Use gradientColors1 directly

  List<Color> get selectedGradient => _selectedGradient;

  set selectedGradient(List<Color> gradient) {
    _selectedGradient = gradient;
    notifyListeners();
  }

  bool _isAlwaysOn = false;

  bool get isAlwaysOn => _isAlwaysOn;

  Future<void> setAlwaysOn(bool value) async {
    _isAlwaysOn = value;
    if(_isAlwaysOn){
      await Wakelock.enable();
    } else{
      await Wakelock.disable();
    }
    notifyListeners();
  }
}
