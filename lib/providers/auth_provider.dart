import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userName;
  String? _userRole;
  bool _isLoading = true; // Flag to track loading state

  bool get isAuthenticated => _token != null;

  String? get userName => _userName;
  bool get isLoading => _isLoading; // Expose loading state
  String? get userRole => _userRole;
  String? get token => _token;
  AuthProvider() {
    _loadTokenFromPreferences();
  }

  Future<void> _loadTokenFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _userName = prefs.getString('userName');
    _userRole = prefs.getString('userRole');
    _isLoading = false; // Set loading to false after loading is complete

    notifyListeners();

    // if (_token != null) {
    //   notifyListeners();
    // }
  }

  Future<void> _saveTokenToPreferences(
      String token, String userName, String userRole) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userName', userName);
    await prefs.setString('userRole', userRole);
  }

  Future<void> _clearTokenFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userName');
    await prefs.remove('userRole');
  }

  Future<String> login(String email, String password) async {
    final url =
        Uri.parse('https://edc-app-vt8t.onrender.com/api/v1/auth/login');
    final response = await http.post(url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      _userName = data['user']['name'];
      _userRole = data['user']['role'];

      // Save token and user details to SharedPreferences
      await _saveTokenToPreferences(_token!, _userName!, _userRole!);

      notifyListeners();

      return userRole!;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> register(String name, String email, String password) async {
    final url =
        Uri.parse('https://edc-app-vt8t.onrender.com/api/v1/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      _userName = data['user']['name'];
      _userRole = data['user']['role'];
      notifyListeners();
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  void logout() async {
    _token = null;
    _userName = null;
    _userRole = null;

    // Clear token and user details from SharedPreferences
    await _clearTokenFromPreferences();
  }
}
