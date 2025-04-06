import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> signOutUser() async {
  try {
    // Sign out from Firebase
    await FirebaseAuth.instance.signOut();

    // Sign out from Google
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    print("User signed out successfully");
  } catch (e) {
    print("Sign out error: $e");
  }
}
