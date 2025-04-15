import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri_chem/providers/user_provider.dart';

//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:agri_chem/firebase_options.dart';
import 'package:agri_chem/authentication/authentication_gate.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if Firebase is already initialized
  if (Firebase.apps.isEmpty) {
    print("Initializing Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    print("Firebase already initialized.");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUser()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Agri Chem', home: const AuthenticationGate());
  }
}
