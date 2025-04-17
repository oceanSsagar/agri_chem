import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:agri_chem/providers/user_provider.dart'; // update with your actual path
import 'package:agri_chem/models/user_info_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();
  File? _avatarImageFile;

  bool _isLoading = false;

  Future<File?> _pickAndCompressImage({required bool isAvatar}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return null;

    final File file = File(picked.path);

    final targetWidth = isAvatar ? 300 : 1080;
    final targetHeight = isAvatar ? 300 : 600;

    final compressed = await FlutterImageCompress.compressAndGetFile(
      file.path,
      "${file.path}_compressed.jpg",
      quality: 75,
      minWidth: targetWidth,
      minHeight: targetHeight,
    );

    return compressed != null ? File(compressed.path) : null;
  }

  Future<String?> _uploadImageToStorage(File file, String path) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(path);
      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  Future<void> _saveChanges(UserInfoModel? user) async {
    setState(() => _isLoading = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = FirebaseFirestore.instance
        .collection('agri_users')
        .doc(uid);

    String? avatarUrl;

    if (_avatarImageFile != null) {
      avatarUrl = await _uploadImageToStorage(
        _avatarImageFile!,
        '$uid/avatar.jpg',
      );
    }
    final updatedData = {
      if (_usernameController.text.isNotEmpty)
        'username': _usernameController.text,
      if (_userTypeController.text.isNotEmpty)
        'userType': _userTypeController.text,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
    };

    await userDoc.update(updatedData);

    // Reload updated user info
    await Provider.of<UserProvider>(context, listen: false).loadUser();

    setState(() => _isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : user == null
              ? const Center(child: Text("User data not available."))
              : Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: "Username",
                        hintText: user.username ?? "Enter your username",
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _userTypeController,
                      decoration: InputDecoration(
                        labelText: "User Type",
                        hintText: user.userType ?? "Enter user type",
                        prefixIcon: const Icon(Icons.badge),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text("Pick Avatar Image"),
                      onPressed: () async {
                        final img = await _pickAndCompressImage(isAvatar: true);
                        if (img != null) {
                          setState(() => _avatarImageFile = img);
                        }
                      },
                    ),
                    if (_avatarImageFile != null)
                      Image.file(_avatarImageFile!, height: 100)
                    else if (user.avatarUrl != null)
                      Image.network(
                        user.avatarUrl!,
                        height: 100,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                Icon(Icons.broken_image),
                      ),

                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text("Save Changes"),
                      onPressed: () => _saveChanges(user),
                    ),
                  ],
                ),
              ),
    );
  }
}
