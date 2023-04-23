import './auth_screens/signIn.dart';
import './auth_screens/signUp.dart';
import './screens/about_us_screen.dart';
import './screens/grocery_screen.dart';
import './screens/recipe_with_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:provider/provider.dart' as provider;
import './screens/tabs_screen.dart';
import './providers/chats_provider.dart';
import './providers/models_provider.dart';
import 'main_splash.dart';
import './screens/get_nutrients_screen.dart';

void main() {
  runApp(
    riverpod.ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(
            create: (_) => ChatProvider(),
          ),
          provider.ChangeNotifierProvider(
            create: (_) => ModelsProvider(),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Recipe And Meals',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
        ),
      ),
      // home:const SignupScreen(),
      // home: SplashScreen(),
      home: ShakeToNavigate(),
      // home:getNutrientsScreen(),
      // home: AboutUsScreen(),
    );
  }
}

