import 'package:edc_app/admin_dashboard_main_body/admin_dashboard.dart';
import 'package:edc_app/providers/auth_provider.dart';
import 'package:edc_app/providers/edc_team.dart';
import 'package:edc_app/providers/event_provider.dart'; // Import EventProvider
import 'package:edc_app/providers/passwordresetProvider.dart';
import 'package:edc_app/providers/public_event_provider.dart';
import 'package:edc_app/providers/public_profile.dart';
import 'package:edc_app/screens.dart/authentication_page.dart/sign_in_page.dart';
import 'package:edc_app/screens.dart/authentication_page.dart/splash_screen.dart';
// import 'package:edc_app/screens.dart/authentication_page.dart/splash_screen.dart';
import 'package:edc_app/screens.dart/bottom_page_navigation.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PublicEventProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => EventProvider()),
        ChangeNotifierProvider(create: (context) => PasswordResetProvider()),
        ChangeNotifierProvider(create: (context) => EdcTeamProvider()),
        ChangeNotifierProvider(create: (context) => PublicProfileProvider()),
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
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
        ),
        useMaterial3: true,
      ),
      home: FutureBuilder<void>(
        future: _initializeApp(
            context), // Initialize the app before deciding the next screen
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While waiting for initialization, show the splash screen
            return const SplashScreen();
          } else if (snapshot.hasError) {
            // Handle error if needed
            return const SignInPage(); // Show sign-in on error
          } else {
            // After initialization, navigate based on authentication state
            return Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                if (authProvider.isLoading) {
                  // Show loading screen while authenticating
                  return const SplashScreen();
                }

                if (authProvider.isAuthenticated) {
                  if (authProvider.userRole == 'admin') {
                    return const AdminDashboard(); // Show Admin Dashboard
                  } else {
                    return const BottomPageNavigation(); // Show bottom navigation for normal users
                  }
                } else {
                  return const SignInPage(); // Show sign-in page if not authenticated
                }
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _initializeApp(BuildContext context) async {
    // Simulate a delay for splash screen effect
    await Future.delayed(const Duration(seconds: 2));
  }
}
