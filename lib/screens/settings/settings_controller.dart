import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

import '../../utils/constants/colors.dart';

class SettingsController extends ChangeNotifier {
  List<Color> _selectedGradient = PomodoroColors.gradientColors1;

  List<Color> get selectedGradient => _selectedGradient;

  set selectedGradient(List<Color> gradient) {
    _selectedGradient = gradient;
    notifyListeners();
  }

  bool _isAlwaysOn = false;

  bool get isAlwaysOn => _isAlwaysOn;

  Future<void> setAlwaysOn(bool value) async {
    if (_isAlwaysOn != value) {
      _isAlwaysOn = value;
      if (_isAlwaysOn) {
        await Wakelock.enable();
      } else {
        await Wakelock.disable();
      }
      notifyListeners();
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAlwaysOn', value);
      } catch (error) {
        print('Error saving setting: $error');
      }
    }
  }

  Future<void> loadSavedSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? savedIsAlwaysOn = prefs.getBool('isAlwaysOn');
      if (savedIsAlwaysOn != null && _isAlwaysOn != savedIsAlwaysOn) {
        _isAlwaysOn = savedIsAlwaysOn;
        notifyListeners();
      }
    } catch (error) {
      print('Error loading saved settings: $error');
    }
  }
}
