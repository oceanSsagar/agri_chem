import 'package:agri_chem/authentication/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; //dotenv
import 'package:agri_chem/themes/app_theme.dart'; //theme import
import 'package:flutter/foundation.dart'; // for example of provider
import 'package:provider/provider.dart';

//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:agri_chem/firebase_options.dart';

Future main() async {
  await dotenv.load(fileName: ".env"); //dotenv
  WidgetsFlutterBinding.ensureInitialized(); //firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Counter())],
      child: const MyApp(),
    ),
  );
}

class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Agri Chem", //Application Name
      theme: AppTheme.lightTheme, //My theme
      darkTheme: AppTheme.darkTheme,
      home:
          AuthGate(), //The app starts with the user being getting authenticating.
    );
  }
}
