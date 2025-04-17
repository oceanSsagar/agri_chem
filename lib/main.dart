import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:agri_chem/providers/user_provider.dart';
import 'package:agri_chem/firebase_options.dart';
import 'package:agri_chem/authentication/authentication_gate.dart';
import 'package:agri_chem/models/chat_message_model.dart'; // Import your Hive model

import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(ChatMessageModelAdapter());
  await Hive.openBox<ChatMessageModel>('chatBox');

  // Load .env file
  await dotenv.load(fileName: ".env");

  // Initialize Firebase
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
    return MaterialApp(
      title: 'Agri Chem',
      debugShowCheckedModeBanner: false,
      home: const AuthenticationGate(),
    );
  }
}
