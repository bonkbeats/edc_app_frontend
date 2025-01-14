import 'package:edc_app/admin_dashboard_main_body/admin_events_page.dart';

import 'package:edc_app/admin_dashboard_main_body/event_list.dart';
import 'package:edc_app/admin_dashboard_main_body/edc_team_profile.dart/edc_team.dart';
import 'package:edc_app/screens.dart/authentication_page.dart/sign_in_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edc_app/providers/auth_provider.dart'; // Make sure the auth provider is imported

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0; // Track the selected page

  // List of pages to display
  final List<Widget> _pages = [
    const EventList(),
    const AdminEventPage(),
    const Edcteam(),
    // const ProfileCreationPage()
  ];

  void _onDrawerItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer after selection
  }

  void _signOut() async {
    // Call logout from AuthProvider
    Provider.of<AuthProvider>(context, listen: false).logout();

    // Navigate to the sign-in page after logging out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.admin_panel_settings,
                      size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Admin Panel',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () => _onDrawerItemTapped(0),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Events'),
              onTap: () => _onDrawerItemTapped(1),
            ),

            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('EDC Team'),
              onTap: () => _onDrawerItemTapped(2),
            ),
            // ListTile(
            //   leading: const Icon(Icons.question_answer),
            //   title: const Text('profile'),
            //   onTap: () => _onDrawerItemTapped(3),
            // ),
            const Divider(), // Optional divider between the last item and Sign Out
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sign Out'),
              onTap: _signOut, // Call the sign out function
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
