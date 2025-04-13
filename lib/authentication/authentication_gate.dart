import 'package:agri_chem/screens/main_screen.dart';
import 'package:agri_chem/themes/my_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agri_chem/utility/sign_in_with_google.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthenticationGate extends StatefulWidget {
  const AuthenticationGate({super.key});

  @override
  State<AuthenticationGate> createState() => _AuthenticationGateState();
}

class _AuthenticationGateState extends State<AuthenticationGate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false; //why??

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return const MainScreen();
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

                  // Google Sign-In Button
                  _isLoading
                      ? const CircularProgressIndicator()
                      : SignInButtonBuilder(
                        text: "Sign in with Google", // Custom text
                        icon: Icons.g_mobiledata, // Optional: Use a custom icon
                        backgroundColor: kPrimaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ), // Custom background color
                        elevation: 5,
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
}
