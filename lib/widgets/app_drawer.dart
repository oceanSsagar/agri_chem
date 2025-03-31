import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("userName"), //need to add after
            accountEmail: Text("useremail"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://appmaking.co/wp-content/uploads/2021/08/appmaking-logo-colored.png", //for dummy
              ),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  "https://appmaking.co/wp-content/uploads/2021/08/android-drawer-bg.jpeg", //for dummy
                ),
                fit: BoxFit.fill,
              ),
            ),
            // otherAccountsPictures: [
            //   CircleAvatar(
            //     backgroundColor: Colors.white,
            //     backgroundImage: NetworkImage(
            //       "https://randomuser.me/api/portraits/women/74.jpg",
            //     ),
            //   ),
            //   CircleAvatar(
            //     backgroundColor: Colors.white,
            //     backgroundImage: NetworkImage(
            //       "https://randomuser.me/api/portraits/men/47.jpg",
            //     ),
            //   ),
            // ],
          ),

          ListTile(
            leading: Icon(Icons.person),
            title: Text("Account"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.attribution_outlined),
            title: Text("About Us"),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
