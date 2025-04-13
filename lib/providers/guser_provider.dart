import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GUserProvider with ChangeNotifier {
  GoogleSignInAccount? _googleUser;

  GoogleSignInAccount? get googleUser => _googleUser;

  // Set the Google user and notify listeners
  void setGoogleUser(GoogleSignInAccount? user) {
    _googleUser = user;
    notifyListeners();
  }

  // Clear the Google user (e.g., during logout)
  void clearGoogleUser() {
    _googleUser = null;
    notifyListeners();
  }

  void clearUser() {
    // Clear user-related data here
    notifyListeners();
  }
}
