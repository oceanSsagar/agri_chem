import 'package:agri_chem/providers/user_provider.dart';
import 'package:agri_chem/screens/application_screens/qr_scan_screen.dart';
import 'package:agri_chem/screens/notification_screen.dart';
import 'package:agri_chem/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

//screens
import 'package:agri_chem/screens/application_screens/home_screen.dart';
import 'package:agri_chem/screens/application_screens/chemical_search_screen.dart';
import 'package:agri_chem/screens/application_screens/modules_screen.dart';
import 'package:provider/provider.dart';
import 'package:agri_chem/screens/application_screens/chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String _title = "Agri Chem";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<UserProvider>(context, listen: false).loadUser();
    });
  }

  _onItemTapped(int index) {
    final titles = ["Home", "Chemical Search", "Modules", "Chat"];
    setState(() {
      _selectedIndex = index;
      _title = titles[index];
    });
  }

  final List<Widget> _screens = [
    HomeScreen(),
    ChemicalSearchScreen(),
    ModulesScreen(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Soft green background
      appBar: AppBar(
        title: Text(
          _title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange, // Rich green
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QrScanScreen()),
              );
            },
            icon: Icon(Icons.qr_code),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationScreen(),
                ),
              );
            },
            icon: const Icon(Icons.notifications),
            tooltip: "Notifications",
          ),
        ],
      ),

      drawer: const AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white, // Slightly darker green
        selectedItemColor: Colors.orange, // Earthy brown
        unselectedItemColor: Colors.black.withAlpha(150),
        selectedFontSize: 14,
        unselectedFontSize: 13,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Modules'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex.clamp(0, _screens.length - 1),
        children: _screens,
      ),
    );
  }
}
