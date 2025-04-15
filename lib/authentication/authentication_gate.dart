import 'package:agri_chem/onboarding/onboarding_screen.dart';
import 'package:agri_chem/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agri_chem/utility/sign_in_with_google.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationGate extends StatefulWidget {
  const AuthenticationGate({super.key});

  @override
  State<AuthenticationGate> createState() => AuthenticationGateState();
}

class AuthenticationGateState extends State<AuthenticationGate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool? _isProfileComplete;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          if (_isProfileComplete == null) {
            _checkProfileStatus(snapshot.data!);
            return const Center(child: CircularProgressIndicator());
          }

          if (_isProfileComplete == true) {
            return const MainScreen();
          } else {
            return const OnboardingScreen();
          }
        }

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

  Future<void> _checkProfileStatus(User user) async {
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('agri_users')
              .doc(user.uid)
              .get();

      final data = doc.data();
      final isCompleted = data != null && data['profileCompleted'] == true;

      setState(() {
        _isProfileComplete = isCompleted;
      });
    } catch (e) {
      print("Error checking profile status: $e");
      setState(() => _isProfileComplete = false);
    }
  }
}
