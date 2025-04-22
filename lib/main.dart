import 'package:agri_chem/notifications/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:agri_chem/providers/user_provider.dart';
import 'package:agri_chem/firebase_options.dart';
import 'package:agri_chem/authentication/authentication_gate.dart';
import 'package:agri_chem/models/chat_message_model.dart';

// ✅ Move this outside of main()
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔕 Background message: ${message.notification?.title}');
}

//navigator global key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Notification Service
  await NotificationService.init();

  // ✅ Load .env file first
  await dotenv.load(fileName: ".env");

  // ✅ Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //forward and background messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 Foreground message: ${message.notification?.title}');
    NotificationService.showNotification(
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
    );
  });

  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request notification permission
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();

  // Handle foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 Foreground message: ${message.notification?.title}');
  });

  // Initialize Hive
  final appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);
  Hive.registerAdapter(ChatMessageModelAdapter());
  await Hive.openBox<ChatMessageModel>('chatBox');

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
      navigatorKey: navigatorKey,
      title: 'Agri Chem',
      debugShowCheckedModeBanner: false,
      home: const AuthenticationGate(),
    );
  }
}
