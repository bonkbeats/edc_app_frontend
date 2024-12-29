import 'package:edc_app/admin_dashboard_main_body/admin_dashboard.dart';
import 'package:edc_app/providers/auth_provider.dart';
import 'package:edc_app/providers/event_provider.dart'; // Import EventProvider
import 'package:edc_app/providers/passwordresetProvider.dart';
import 'package:edc_app/providers/public_event_provider.dart';
import 'package:edc_app/screens.dart/authentication_page.dart/sign_in_page.dart';
import 'package:edc_app/screens.dart/bottom_page_navigation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => PublicEventProvider()),
        ChangeNotifierProvider(create: (context) => PasswordResetProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.blue,
          selectedItemColor: Color.fromARGB(255, 43, 14, 231),
          unselectedItemColor: Colors.grey,
        ),
        useMaterial3: true,
      ),
      // Use a Consumer widget to rebuild the UI based on authentication state
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          // If data is still loading, show a loading screen
          if (authProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if the user is logged in
          if (authProvider.isAuthenticated) {
            // If the user is authenticated, check their role
            if (authProvider.userRole == 'admin') {
              // Navigate to Admin Dashboard if the user is an admin
              return const AdminDashboard();
            } else {
              // Navigate to Bottom Navigation Page if the user is a regular user
              return const BottomPageNavigation();
            }
          } else {
            // If not authenticated, show the sign-in page
            return const SignInPage();
          }
        },
      ),
    );
  }
}
