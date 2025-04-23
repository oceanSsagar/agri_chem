import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agri_chem/providers/user_provider.dart';
import 'package:agri_chem/models/user_info_model.dart';
// Keep all the imports as-is

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _isSaving = false;
  File? _avatarImageFile;

  // Refresh callback to reload user data
  Future<void> _refreshUserData() async {
    // Trigger the loadUser method to refresh the user data from Firestore
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUser(
      forceReload: true,
    ); // Force reload to get fresh data
  }

  Future<File?> _pickAndCompressImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return null;

    final file = File(picked.path);
    final compressed = await FlutterImageCompress.compressAndGetFile(
      file.path,
      "${file.path}_compressed.jpg",
      quality: 75,
      minWidth: 300,
      minHeight: 300,
    );

    return compressed != null ? File(compressed.path) : null;
  }

  Future<String?> _uploadImageToStorage(File file, String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('agrichem/images/$path');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  Future<void> _saveChanges(UserInfoModel user) async {
    setState(() => _isSaving = true);

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

    final updatedData = {if (avatarUrl != null) 'avatarUrl': avatarUrl};

    await userDoc.update(updatedData);
    await Provider.of<UserProvider>(context, listen: false).loadUser();

    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (!_isSaving)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                if (user != null) _saveChanges(user);
              },
            ),
        ],
      ),
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _refreshUserData, // Trigger the refresh
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundColor: const Color.fromARGB(
                              255,
                              204,
                              241,
                              173,
                            ),
                            backgroundImage:
                                _avatarImageFile != null
                                    ? FileImage(_avatarImageFile!)
                                    : user.avatarUrl != null
                                    ? CachedNetworkImageProvider(
                                      user.avatarUrl!,
                                    )
                                    : const AssetImage(
                                          'assets/images/default_avatar.jpg',
                                        )
                                        as ImageProvider,
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () async {
                                final picked = await _pickAndCompressImage();
                                if (picked != null) {
                                  setState(() => _avatarImageFile = picked);
                                }
                              },
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.green,
                                child: const Icon(
                                  Icons.edit,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _infoCard(
                        Icons.person,
                        "Username",
                        user.username ?? "Not provided",
                      ),
                      _infoCard(
                        Icons.email,
                        "Email",
                        user.email ?? "Not provided",
                      ),
                      _infoCard(
                        Icons.phone,
                        "Phone Number",
                        user.phoneNumber ?? "Not provided",
                      ),
                      _infoCard(
                        Icons.person,
                        "User Type",
                        user.userType ?? "N/A",
                      ),
                      _infoCard(
                        Icons.language,
                        "Language",
                        user.languagePreference ?? "English",
                      ),
                      const SizedBox(height: 20),
                      if (_isSaving) const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700]),
        title: Text(title),
        subtitle: Text(value, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}
