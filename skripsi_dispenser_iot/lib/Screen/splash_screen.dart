import 'package:flutter/material.dart';
import 'package:skripsi_dispenser_iot/const.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:skripsi_dispenser_iot/Screen/login_screen.dart';
import 'package:skripsi_dispenser_iot/firebase_options.dart';

class SplashScreen extends StatefulWidget {

  static String id = "SplashScreen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    Future.delayed(const Duration(seconds: 2), () async{
      Navigator.popAndPushNamed(context, LoginScreen.id);}
    );
  }

  @override
  void deactivate(){
    super.deactivate();
    print("LoadingScreen-Deleted");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kBGBiru,
        child: Center(
            child: Hero(
                tag: 'botolair',
                child: Image.asset("images/SplashScreen.png", width: 230, height: 200)))
    );
  }
}
