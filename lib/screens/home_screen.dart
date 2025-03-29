import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String appName = dotenv.get('APP_NAME', fallback: "MyApp");
  int _selectedIndex = 0;

  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //AppBar Name
        title: Text(appName),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      //App Drawer
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            TextButton(onPressed: () {}, child: Text("settings")),
          ],
        ),
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'AI'),
        ],
      ),
      body: Center(child: Text("Hello World!")),
    );
  }
}
