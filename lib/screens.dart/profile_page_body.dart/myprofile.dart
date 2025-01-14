import 'package:edc_app/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Myprofile extends StatelessWidget {
  const Myprofile({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${authProvider.userName ?? 'Guest'}!'),
      ),
      body: Center(
        child: authProvider.isAuthenticated
            ? Text('Hello, ${authProvider.userName}!')
            : const Text('Please log in.'),
      ),
    );
  }
}
