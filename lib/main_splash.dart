import 'screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './auth_screens/signIn.dart';
import './auth_screens/signUp.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // add a delay to simulate a longer loading time
    Future.delayed(const Duration(seconds: 2), () {
      // navigate to ShakeToNavigate() after the splash screen has finished
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SignupScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // remove the system overlay for the status bar
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash_screen_background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
        child: Image(
          image: AssetImage("assets/images/splash_screen_logo.png"),
        ),
      ),
    );
  }
}
