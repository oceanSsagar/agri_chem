import 'package:flutter/material.dart';
import 'package:agri_chem/screens/home_screen.dart'; //home screen
import 'package:flutter_dotenv/flutter_dotenv.dart'; //dotenv
import 'package:agri_chem/themes/app_theme.dart'; //theme import

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agri Chem", //Application Name
      theme: AppTheme.lightTheme, //My theme
      darkTheme: AppTheme.darkTheme,
      home: HomeScreen(),
    );
  }
}
