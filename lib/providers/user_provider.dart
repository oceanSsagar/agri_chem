import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_info_model.dart';

class UserProvider with ChangeNotifier {
  UserInfoModel? _user;

  UserInfoModel? get user => _user;

  /// Loads user data from Firestore. Set [forceReload] to true to reload even if already loaded.
  Future<void> loadUser({bool forceReload = false}) async {
    if (_user != null && !forceReload) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('agri_users')
            .doc(currentUser.uid)
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      _user = UserInfoModel.fromMap({
        'uid': currentUser.uid,
        'email': currentUser.email,
        'phoneNumber': currentUser.phoneNumber,
        'avatarUrl': data['avatarUrl'],
        'username': data['username'],
        'userType': data['userType'],
        'languagePreference': data['languagePreference'],
        'firstName': data['firstName'] ?? '',
        'lastName': data['lastName'] ?? '',
        'gender': data['gender'] ?? '',
        'profileCompleted': data['profileCompleted'] ?? false,
        'createdAt': data['createdAt'],
      });
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
