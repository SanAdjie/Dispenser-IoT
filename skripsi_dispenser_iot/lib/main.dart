import 'package:flutter/material.dart';
import 'package:skripsi_dispenser_iot/Screen/splash_screen.dart';
import 'package:skripsi_dispenser_iot/Screen/main_screen.dart';
import 'package:skripsi_dispenser_iot/Screen/login_screen.dart';
import 'package:skripsi_dispenser_iot/component/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dispenser IoT x Water-Reminder App',
      theme: ThemeData(
          primaryColor: kBGBiru,
          focusColor: kBGBiru,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(
                color: kBGAbu3))),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id : (context) => SplashScreen(),
        MainScreen.id : (context) => MainScreen(),
        LoginScreen.id : (context) => LoginScreen()
      },
    );
  }
}
