import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PasswordResetProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Forgot Password API call
  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(
            'http://157.245.107.86:4000/api/v1/auth/forgotpassword'), // Your backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        _errorMessage = 'Password reset link has been sent to your email!';
      } else {
        final responseData = json.decode(response.body);
        _errorMessage = responseData['message'] ?? 'Something went wrong.';
      }
    } catch (error) {
      _errorMessage = 'Failed to send request. Please try again later.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset Password API call
  Future<void> resetPassword(String token, String newPassword) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(
            'http://157.245.107.86:4000/api/v1/auth/resetpassword/$token'), // Your backend URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'password': newPassword}),
      );

      if (response.statusCode == 200) {
        _errorMessage = 'Password reset successful!';
      } else {
        final responseData = json.decode(response.body);
        _errorMessage = responseData['message'] ?? 'Something went wrong.';
      }
    } catch (error) {
      _errorMessage = 'Failed to reset password. Please try again later.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
