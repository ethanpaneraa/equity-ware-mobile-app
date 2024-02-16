import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/notifications.dart';
import 'screens/settings.dart';
void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState(); 
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 1;
  final List<Widget> _widgetOptions =[
    NotificationsPage(), 
    HomeScreen(),
    SettingsPage(),
      // this is where you add the other screens
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _widgetOptions,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.circle_notifications),
              label: 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            // Add other navigation bar items here
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color.fromRGBO(69, 103, 81, 1.0),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}