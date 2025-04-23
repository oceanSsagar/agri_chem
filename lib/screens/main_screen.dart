import 'package:agri_chem/providers/navigation_provider.dart';
import 'package:agri_chem/screens/application_screens/qr_scan_screen.dart';
import 'package:agri_chem/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screens
import 'package:agri_chem/screens/application_screens/home_screen.dart';
import 'package:agri_chem/screens/application_screens/chemical_search_screen.dart';
import 'package:agri_chem/screens/application_screens/modules_screen.dart';
import 'package:agri_chem/screens/application_screens/chat_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final List<String> _titles = ["Home", "Chemical Search", "Modules", "Chat"];

  final List<Widget> _screens = [
    HomeScreen(),
    ChemicalSearchScreen(),
    ModulesScreen(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Load user once when the widget builds
    final navProvider = Provider.of<NavigationProvider>(context);

    final navigationProvider = Provider.of<NavigationProvider>(context);
    final selectedIndex = navigationProvider.selectedIndex;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9), // Soft green background
      appBar: AppBar(
        title: Text(
          _titles[selectedIndex],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.orange,
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
            icon: const Icon(Icons.qr_code),
          ),
        ],
      ),

      drawer: const AppDrawer(),
      body: IndexedStack(index: navProvider.selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black.withAlpha(150),
        selectedFontSize: 14,
        unselectedFontSize: 13,
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: (index) => navProvider.setIndex(index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Modules'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}
