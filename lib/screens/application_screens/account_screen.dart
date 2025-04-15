import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri_chem/providers/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'edit_profile_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
      ),
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background Banner
                      SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.green[100]!, Colors.green[300]!],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child:
                                user.avatarUrl != null
                                    ? CachedNetworkImage(
                                      imageUrl: user.avatarUrl!,
                                      width: 96,
                                      height: 96,
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) =>
                                              const CircularProgressIndicator(),
                                      errorWidget:
                                          (context, url, error) => const Image(
                                            image: AssetImage(
                                              'assets/images/default_avatar.jpg',
                                            ),
                                            fit: BoxFit.cover,
                                            width: 96,
                                            height: 96,
                                          ),
                                    )
                                    : const Image(
                                      image: AssetImage(
                                        'assets/images/default_avatar.jpg',
                                      ),
                                      fit: BoxFit.cover,
                                      width: 96,
                                      height: 96,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Text(
                    user.username ?? "Anonymous",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _infoCard(Icons.email, "Email", user.email ?? "Not provided"),
                  _infoCard(
                    Icons.phone,
                    "Phone Number",
                    user.phoneNumber ?? "Not provided",
                  ),
                  _infoCard(Icons.person, "User Type", user.userType ?? "N/A"),
                  _infoCard(
                    Icons.language,
                    "Language",
                    user.languagePreference ?? "English",
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text("Edit Profile"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(value),
        ),
      ),
    );
  }
}
