import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agri_chem/utils/account_utils.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? _avatarImage;
  File? _backgroundImage;
  String? _avatarUrl;
  String? _backgroundUrl;

  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (userDoc.exists) {
        final data = userDoc.data() ?? {}; // Get the document data as a Map
        setState(() {
          // Check if the fields exist, otherwise use default values
          _avatarUrl =
              data.containsKey('avatarUrl')
                  ? data['avatarUrl']
                  : 'assets/images/default_avatar.jpg';
          _backgroundUrl =
              data.containsKey('backgroundUrl')
                  ? data['backgroundUrl']
                  : 'assets/images/default_background.jpg';
          _usernameController.text =
              data.containsKey('username')
                  ? data['username']
                  : 'Anonymous User';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                _backgroundImage != null
                    ? Image.file(
                      _backgroundImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                    : _backgroundUrl != null &&
                        !_backgroundUrl!.startsWith('assets/')
                    ? Image.network(
                      _backgroundUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                    : Image.asset(
                      _backgroundUrl ?? 'assets/images/default_background.jpg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                CircleAvatar(
                  backgroundImage:
                      _avatarImage != null
                          ? FileImage(_avatarImage!)
                          : _avatarUrl != null &&
                              !_avatarUrl!.startsWith('assets/')
                          ? NetworkImage(_avatarUrl!)
                          : AssetImage(
                                _avatarUrl ??
                                    'assets/images/default_avatar.jpg',
                              )
                              as ImageProvider,
                  radius: 50,
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => updateUsername(context, _usernameController),
              child: const Text("Update Username"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  () => pickImage(
                    ImageSource.gallery,
                    true,
                    (file) => setState(() => _avatarImage = file),
                  ),
              child: const Text("Change Avatar"),
            ),
            ElevatedButton(
              onPressed:
                  () => pickImage(
                    ImageSource.gallery,
                    false,
                    (file) => setState(() => _backgroundImage = file),
                  ),
              child: const Text("Change Background"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  () => uploadImages(context, _avatarImage, _backgroundImage),
              child: const Text("Upload Images"),
            ),
          ],
        ),
      ),
    );
  }
}
