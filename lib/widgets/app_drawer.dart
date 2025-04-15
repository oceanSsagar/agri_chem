import 'package:agri_chem/screens/application_screens/aboutus_screen.dart';
import 'package:agri_chem/screens/application_screens/settings_screen.dart';
import 'package:agri_chem/utility/sign_out.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agri_chem/screens/application_screens/account_screen.dart';
import 'package:agri_chem/themes/my_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                          ? CachedNetworkImageProvider(avatarUrl)
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                ),
                decoration: BoxDecoration(color: Colors.greenAccent),
              ),

              ListTile(
                leading: Icon(Icons.person),
                title: Text("Account"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AccountScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.attribution_outlined),
                title: Text("About Us"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsScreen(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () => signOutUser(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
