import 'package:agri_chem/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart'; // for later-> dotenv package

//screens
import 'package:agri_chem/screens/application_screens/home_screen.dart';
import 'package:agri_chem/screens/application_screens/feed_screen.dart';
import 'package:agri_chem/screens/application_screens/modules_screen.dart';
import 'package:agri_chem/screens/application_screens/chat_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // as list of screens for bottomnavigationbar
  final List<Widget> _screens = [
    HomeScreen(),
    FeedScreen(),
    ModulesScreen(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar Name
        title: Text("AgriChem"),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      //App Drawer
      drawer: AppDrawer(),
      //Bottom Navigatio Bar (ofcourse for navigation in app)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        enableFeedback: true, //haptics
        backgroundColor: Theme.of(context).colorScheme.primary,
        fixedColor: Theme.of(context).colorScheme.onPrimary,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_rounded),
            label: 'feed',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Modules'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
      body:
          _screens[_selectedIndex], //using the index to toggle btw the screens
    );
  }
}
