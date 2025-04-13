import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri_chem/providers/guser_provider.dart';

//firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:agri_chem/firebase_options.dart';
import 'package:agri_chem/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agri_chem/utility/sign_in_with_google.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:agri_chem/onboarding/onboarding_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    print("Firebase is empty");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    print("Firebase is not empty");
  }

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GUserProvider())],
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

class AuthenticationGate extends StatefulWidget {
  const AuthenticationGate({super.key});

  @override
  State<AuthenticationGate> createState() => _AuthenticationGateState();
}

class _AuthenticationGateState extends State<AuthenticationGate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false; // Loading state for the sign-in button
  bool? _isNewUser; // Cache the result of whether the user is new

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // User is signed in, check if they are new
          if (_isNewUser == null) {
            // Only calculate if _isNewUser is null
            _checkIfNewUser(snapshot.data!);
            return const Center(child: CircularProgressIndicator());
          }

          if (_isNewUser == true) {
            // First-time user, navigate to OnboardingScreen
            return OnboardingScreen();
          } else {
            // Returning user, navigate to MainScreen
            return const MainScreen();
          }
        }

        // User is not signed in, show the sign-in screen
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Image.asset("assets/images/icon.png", height: 100),
                  const SizedBox(height: 20),
                  const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Google Sign-In Button
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SignInButton(
                        Buttons.Google,
                        onPressed: () async {
                          setState(() => _isLoading = true);
                          try {
                            await signInWithGoogle(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        },
                      ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to check if the user is new
  Future<void> _checkIfNewUser(User user) async {
    try {
      await user.reload(); // Reload user to get the latest metadata
      final currentUser = FirebaseAuth.instance.currentUser;
      final isNewUser =
          currentUser?.metadata.creationTime ==
          currentUser?.metadata.lastSignInTime;

      setState(() {
        _isNewUser = isNewUser;
      });
    } catch (e) {
      print("Error checking if user is new: $e");
      setState(() {
        _isNewUser = false; // Default to returning user in case of error
      });
    }
  }
}
