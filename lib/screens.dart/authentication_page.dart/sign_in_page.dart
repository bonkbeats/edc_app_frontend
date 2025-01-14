import 'package:edc_app/admin_dashboard_main_body/admin_dashboard.dart';
import 'package:edc_app/providers/auth_provider.dart';
import 'package:edc_app/providers/passwordresetProvider.dart';
import 'package:edc_app/screens.dart/authentication_page.dart/sign_up_page.dart';
import 'package:edc_app/screens.dart/bottom_Page_Navigation.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo and Title
              const Column(
                children: [
                  Image(
                    image: AssetImage(
                        'assets/images/edc_logo.png'), // Reference the image
                    width: 160, // Set desired width
                    height: 160, // Set desired height
                  ),
                  SizedBox(height: 10),
                  // Text(
                  //   'EDC',
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 30),

              // Error Message
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Sign-In Form
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Sign in',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'abc@email.com',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(
                              255, 238, 235, 235), // Light grey color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Your password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Remember Me and Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value;
                          });
                        },
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      _showForgotPasswordDialog(context);
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sign-In Button
              ElevatedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_emailController.text.isEmpty ||
                            !_emailController.text.contains('@')) {
                          setState(() {
                            errorMessage = "Please enter a valid email.";
                          });
                          return;
                        }
                        if (_passwordController.text.isEmpty) {
                          setState(() {
                            errorMessage = "Password cannot be empty.";
                          });
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                          errorMessage = null;
                        });

                        try {
                          final role = await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .login(_emailController.text,
                                  _passwordController.text);

                          if (role == 'admin') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AdminDashboard()),
                            );
                          } else
                          //  if (role == 'user')
                          {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomPageNavigation()),
                            );
                          }
                          debugPrint(role);
                          //  else {
                          //   setState(() {
                          //     errorMessage = "Unknown user role.";
                          //   });
                          // }
                        } catch (e) {
                          setState(() {
                            errorMessage = "Login failed. Please try again.";
                          });
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : const Text(
                        'SIGN IN',
                        style: TextStyle(color: Colors.white),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D56F0),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // OR Divider
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      );
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showForgotPasswordDialog(BuildContext context) {
  final TextEditingController emailController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Forgot Password'),
        content: TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'Enter your email'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final passwordResetProvider =
                  Provider.of<PasswordResetProvider>(context, listen: false);

              await passwordResetProvider.forgotPassword(emailController.text);

              if (passwordResetProvider.errorMessage.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(passwordResetProvider.errorMessage)),
                );
              }

              if (passwordResetProvider.errorMessage
                  .contains('Password reset link has been sent')) {
                Navigator.pop(context); // Close the forgot dialog
                _showResetPasswordDialog(context); // Open the reset dialog
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      );
    },
  );
}

void _showResetPasswordDialog(BuildContext context) {
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tokenController,
              decoration: const InputDecoration(labelText: 'Reset Token'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final passwordResetProvider =
                  Provider.of<PasswordResetProvider>(context, listen: false);

              await passwordResetProvider.resetPassword(
                tokenController.text,
                newPasswordController.text,
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(passwordResetProvider.errorMessage)),
              );

              if (passwordResetProvider.errorMessage
                  .contains('Password reset successful')) {
                Navigator.pop(context); // Close the reset dialog
              }
            },
            child: const Text('Reset Password'),
          ),
        ],
      );
    },
  );
}
