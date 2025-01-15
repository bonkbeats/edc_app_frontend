//import 'package:edc_app/screens.dart/events_Page.dart';
import 'package:edc_app/screens.dart/home_Page.dart';
import 'package:edc_app/screens.dart/profile_page_body.dart/profile_page.dart';
import 'package:edc_app/screens.dart/team_page.dart';
import 'package:flutter/material.dart';

class BottomPageNavigation extends StatefulWidget {
  const BottomPageNavigation({super.key});

  @override
  State<BottomPageNavigation> createState() => _BottomPageNavigationState();
}

class _BottomPageNavigationState extends State<BottomPageNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    PublicProfileScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_currentIndex != index) {
            // Prevent redundant calls
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.group),
            label: 'Team',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
