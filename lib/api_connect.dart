import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _userName;
  String? _userRole;

  bool get isAuthenticated => _token != null;

  String? get userName => _userName;
  String? get userRole => _userRole;

  get token => null;

  Future<void> login(String email, String password) async {
    final url = Uri.parse('http://localhost:4000/login');
    final response = await http.post(url,
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      _userName = data['user']['name'];
      _userRole = data['user']['role'];
      notifyListeners();
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> register(String name, String email, String password) async {
    final url = Uri.parse('http://localhost:4000/register');
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

  void logout() {
    _token = null;
    _userName = null;
    _userRole = null;
    notifyListeners();
  }
}
