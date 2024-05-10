import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pomodoro/screens/settings/settings_controller.dart';
import 'package:pomodoro/screens/welcome_screen.dart';
import 'package:pomodoro/utils/theme/app_theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsController(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const WelcomeScreen(),
        theme: const PomodoroAppTheme().themeData,
      ),
    );
  }
}
