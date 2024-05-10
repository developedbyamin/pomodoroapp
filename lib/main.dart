import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pomodoro/screens/home/home_screen.dart';
import 'package:pomodoro/screens/settings/settings_controller.dart';
import 'package:pomodoro/screens/welcome_screen.dart';
import 'package:pomodoro/utils/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsController(),
      child: FutureBuilder(
        future: _checkFirstLaunch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              home: snapshot.data,
              theme: const PomodoroAppTheme().themeData,
            );
          } else {
            // You can return a loading indicator here if needed
            return Container();
          }
        },
      ),
    );
  }
}

Future<Widget> _checkFirstLaunch() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('first_launch') ?? true;
  if (isFirstLaunch) {
    // If it's the first launch, navigate to WelcomeScreen and set first_launch to false
    prefs.setBool('first_launch', false);
    return const WelcomeScreen();
  } else {
    // If it's not the first launch, navigate to HomeScreen
    return const HomeScreen();
  }
}
