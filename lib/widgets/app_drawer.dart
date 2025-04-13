import 'package:agri_chem/utility/sign_out.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agri_chem/screens/application_screens/account_screen.dart';
import 'package:agri_chem/themes/my_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userDoc =
            await FirebaseFirestore.instance
                .collection('agri_users')
                .doc(user.uid)
                .get();
        if (userDoc.exists) {
          return userDoc.data() ?? {};
        }
      }
      return {};
    } catch (e) {
      print("Error fetching user data: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print("Error in FutureBuilder: ${snapshot.error}");
            return const Center(child: Text("Error loading user data"));
          }

          final userData = snapshot.data ?? {};
          final avatarUrl = userData['avatarUrl'];
          final backgroundUrl = userData['backgroundUrl'];
          final userName = userData['username'] ?? "User Name";
          final userEmail = userData['email'] ?? "useremail@example.com";

          return ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  userName,
                  style: const TextStyle(color: kFont),
                ),
                accountEmail: Text(
                  userEmail,
                  style: const TextStyle(color: kFont),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      avatarUrl != null
                          ? NetworkImage(avatarUrl)
                          : const AssetImage('assets/images/default_avatar.jpg')
                              as ImageProvider,
                ),
                decoration: BoxDecoration(
                  image:
                      backgroundUrl != null
                          ? DecorationImage(
                            image: NetworkImage(backgroundUrl),
                            fit: BoxFit.cover,
                          )
                          : null,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.attribution_outlined),
                title: const Text("About Us"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text("Settings"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () => signOutUser(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
