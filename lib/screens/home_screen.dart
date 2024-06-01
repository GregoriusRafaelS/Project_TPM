import 'package:flutter/material.dart';
import 'package:musik_app/screens/profile_screen.dart';
import 'package:musik_app/screens/spotify_screen.dart';

import 'additional_features_screen.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // String name = extractNameFromEmail(widget.userData['email']);

    List<Widget> _widgetOptions = <Widget>[
      SpotifyScreen(),
      AdditionalFeaturesScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_center),
            label: 'Additional',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  String extractNameFromEmail(String email) {
    String namePart = email.split('@')[0];
    String name = namePart.replaceAll('.', ' ');
    return name;
  }
}
