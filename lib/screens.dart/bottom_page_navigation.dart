import 'package:edc_app/screens.dart/events_Page.dart';
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
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          Center(child: HomePage()),
          Center(child: EventsPage()),
          Center(child: PublicProfileScreen()),
          Center(child: ProfilePage()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0, // Remove shadow or elevation
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.white,
            icon: Icon(Icons.event),
            label: 'Event',
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
