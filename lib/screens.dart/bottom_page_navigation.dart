import 'package:edc_app/screens.dart/events_Page.dart';
import 'package:edc_app/screens.dart/home_Page.dart';

import 'package:edc_app/screens.dart/profile_page_body.dart/profile_page.dart';
import 'package:edc_app/screens.dart/team_Page.dart';
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
          Center(child: teamPage()),
          Center(child: ProfilePage()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
