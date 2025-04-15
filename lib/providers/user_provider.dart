import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_info_model.dart';

class UserProvider with ChangeNotifier {
  UserInfoModel? _user;

  UserInfoModel? get user => _user;

  Future<void> loadUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('agri_users')
              .doc(currentUser.uid)
              .get();

      if (doc.exists) {
        _user = UserInfoModel.fromMap({
          'uid': currentUser.uid,
          'email': currentUser.email,
          'phoneNumber': currentUser.phoneNumber,
          'avatarUrl': doc['avatarUrl'],
          'backgroundUrl': doc['backgroundUrl'],
          'username': doc['username'],
          'userType': doc['userType'],
          'languagePreference': doc['languagePreference'],
        });
        notifyListeners();
      }
    }
  }
}
