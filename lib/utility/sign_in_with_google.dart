import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:agri_chem/providers/guser_provider.dart';

Future<UserCredential?> signInWithGoogle(context) async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // The user canceled the sign-in
      print('Google sign-in was canceled by the user.');
      return null;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    if (googleAuth?.accessToken == null && googleAuth?.idToken == null) {
      throw FirebaseAuthException(
        code: 'MISSING_CREDENTIALS',
        message: 'Access token and ID token are both null.',
      );
    }

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Sign in to Firebase with the Google credential
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    // Save the user data
    final isSaved = await saveUser(googleUser, userCredential.user);
    if (!isSaved) {
      print("Failed to save user data.");
    }

    // Store the user in the UserProvider
    Provider.of<GUserProvider>(
      context,
      listen: false,
    ).setGoogleUser(googleUser);

    return userCredential;
  } catch (e) {
    print('Error during Google sign-in: $e');
    return null;
  }
}

Future<bool> saveUser(GoogleSignInAccount account, User? user) async {
  try {
    if (user == null) throw Exception("No authenticated user found.");

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    // Check if the user document already exists
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // If the user does not exist, add them to Firestore
      await userDoc.set({
        'userId': user.uid,
        'email': account.email,
        'displayName': account.displayName ?? 'Anonymous User',
        'photoUrl':
            account.photoUrl ?? 'https://example.com/default-avatar.png',
      });
      print("User data saved successfully.");
    } else {
      print("User already exists in Firestore.");
    }
    return true; // Success
  } catch (error) {
    print("Failed to save user data for ${account.email}: $error");
    return false; // Failure
  }
}
