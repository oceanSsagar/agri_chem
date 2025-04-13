import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:agri_chem/providers/guser_provider.dart';

Future<void> loadUserData(TextEditingController usernameController) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    final userDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    if (userDoc.exists) {
      usernameController.text = userDoc['username'] ?? '';
    }
  }
}

Future<void> uploadImages(
  BuildContext context,
  File? avatarImage,
  File? backgroundImage,
) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("No authenticated user found.");
    }

    final storageRef = FirebaseStorage.instance.ref();
    String? avatarUrl;
    String? backgroundUrl;

    // Upload avatar image
    if (avatarImage != null) {
      final avatarRef = storageRef.child('agrichem/avatars/${user.uid}.jpg');
      await avatarRef.putFile(avatarImage);
      avatarUrl = await avatarRef.getDownloadURL();
    }

    // Upload background image
    if (backgroundImage != null) {
      final backgroundRef = storageRef.child(
        'agrichem/backgrounds/${user.uid}.jpg',
      );
      await backgroundRef.putFile(backgroundImage);
      backgroundUrl = await backgroundRef.getDownloadURL();
    }

    // Save URLs to Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'avatarUrl': avatarUrl,
      'backgroundUrl': backgroundUrl,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Images uploaded successfully!")),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Error uploading images: $e")));
  }
}

Future<void> updateUsername(
  BuildContext context,
  TextEditingController usernameController,
) async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("No authenticated user found.");
    }

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'username': usernameController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Username updated successfully!")),
    );
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Error updating username: $e")));
  }
}

Future<void> pickImage(
  ImageSource source,
  bool isAvatar,
  Function(File) onImagePicked,
) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);

  if (pickedFile != null) {
    onImagePicked(File(pickedFile.path));
  }
}

Future<void> signOutUser(BuildContext context) async {
  try {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Provider.of<GUserProvider>(context, listen: false).clearUser();

    // Navigate to the AuthenticationGate or Login Screen
    Navigator.pushReplacementNamed(context, '/auth');
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Error signing out: $e")));
  }
}
