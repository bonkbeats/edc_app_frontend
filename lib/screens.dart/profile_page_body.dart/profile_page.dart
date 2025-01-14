import 'package:edc_app/providers/auth_provider.dart';
import 'package:edc_app/screens.dart/authentication_page.dart/sign_in_page.dart';

import 'package:edc_app/screens.dart/profile_page_body.dart/myprofile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 254, 254, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section

            Image.asset(
              'assets/images/edc_logo.png',
              height: 160,
              width: 160,
            ),
            const SizedBox(height: 20),

            // Divider
            const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            const SizedBox(height: 20),

            // Options Section
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                    ),
                    title: const Text(
                      'My Profile',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Myprofile()),
                      );

                      // Navigate to My Profile screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.email,
                    ),
                    title: const Text(
                      'Contact Us',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      // Navigate to Contact Us screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.help,
                    ),
                    title: const Text(
                      'Help & FAQs',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {
                      // Navigate to Help & FAQs screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                    ),
                    title: const Text(
                      'Sign Out',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () async {
                      // Call the logout method from AuthProvider
                      Provider.of<AuthProvider>(context, listen: false)
                          .logout();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignInPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
