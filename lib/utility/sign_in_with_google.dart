import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle() async {
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

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print('Error during Google sign-in: $e');
    return null;
  }
}
