import 'package:agri_chem/authentication/authentication_gate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signOutUser(BuildContext context) async {
  try {
    // Sign out from Google
    await GoogleSignIn().signOut();

    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Navigate to the sign-in page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthenticationGate()),
    ); // Replace '/auth' with your sign-in route
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Error signing out: $e")));
  }
}
