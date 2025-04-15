import 'package:agri_chem/screens/notification_screen.dart';
import 'package:agri_chem/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

//screens
import 'package:agri_chem/screens/application_screens/home_screen.dart';
import 'package:agri_chem/screens/application_screens/chemical_search_screen.dart';
import 'package:agri_chem/screens/application_screens/modules_screen.dart';
import 'package:agri_chem/screens/application_screens/chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String _title = "Agri Chem";

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          _title = "Home";
          break;
        case 1:
          _title = "Chemical Search";
          break;
        case 2:
          _title = "Modules";
          break;
        case 3:
          _title = "Chat";
          break;
      }
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
        backgroundColor: const Color(0xFF388E3C), // Rich green
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
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
        backgroundColor: const Color(0xFFD0E8D0), // Slightly darker green
        selectedItemColor: const Color(0xFF5D4037), // Earthy brown
        unselectedItemColor: const Color(0xFF795548).withOpacity(0.6),
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
      body: _screens[_selectedIndex],
    );
  }
}
