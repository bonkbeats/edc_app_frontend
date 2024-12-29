import 'package:edc_app/providers/auth_provider.dart';
import 'package:edc_app/screens.dart/authentication_page.dart/sign_in_page.dart';
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
    return Column(
      children: [
        // User Profile Section
        Container(
          padding: const EdgeInsets.fromLTRB(0, 40, 230, 0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage(
                    'path/to/profile_image.jpg'), // Replace with your actual image path
              ),
              SizedBox(height: 10.0),
              Text(
                'Ujjawal Aman',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        const Divider(
          color: Colors.grey, // Color of the line
          thickness: 2, // Thickness of the line
        ),

        // Options Section
        Expanded(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('My Profile'),
                onTap: () {
                  // Navigate to My Profile screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Contact Us'),
                onTap: () {
                  // Navigate to Contact Us screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & FAQs'),
                onTap: () {
                  // Navigate to Help & FAQs screen
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Sign Out'),
                onTap: () async {
                  // Call the logout method from AuthProvider
                  Provider.of<AuthProvider>(context, listen: false).logout();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
