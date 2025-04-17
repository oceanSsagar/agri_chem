import 'package:agri_chem/providers/user_provider.dart';
import 'package:agri_chem/screens/application_screens/aboutus_screen.dart';
import 'package:agri_chem/screens/application_screens/account_screen.dart';
import 'package:agri_chem/screens/application_screens/dev_screen.dart';
import 'package:agri_chem/screens/application_screens/settings_screen.dart';
import 'package:agri_chem/themes/my_colors.dart';
import 'package:agri_chem/utility/sign_out.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    if (user == null) {
      return const Drawer(child: Center(child: CircularProgressIndicator()));
    }

    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              user.username ?? "User Name",
              style: const TextStyle(color: kFont),
            ),
            accountEmail: Text(
              user.email ?? "useremail@example.com",
              style: const TextStyle(color: kFont),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                      ? CachedNetworkImageProvider(user.avatarUrl!)
                      : const AssetImage('assets/images/default_avatar.png')
                          as ImageProvider,
            ),
            decoration: const BoxDecoration(color: Colors.greenAccent),
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Account"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About Us"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutUsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.developer_mode),
            title: const Text("Dev Page"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DevScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => signOutUser(context),
          ),
        ],
      ),
    );
  }
}
