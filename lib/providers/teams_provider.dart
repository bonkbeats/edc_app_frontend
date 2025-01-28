import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TeamProvider extends ChangeNotifier {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Function to create a new team
  Future<void> createTeam({
    required String eventName,
    required String teamName,
    required List<String> emailIds,
  }) async {
    debugPrint(">>>>>>>>>>>>>>>>>>>>> Testing create team");

    try {
      // Retrieve token from SharedPreferences
      final token = await _getToken();
      debugPrint(token);

      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // Prepare URI for the team creation endpoint
      final uri = Uri.parse('http://localhost:4000/api/v1/user/userdashboard');

      // Create the POST request
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'eventName': eventName,
          'teamName': teamName,
          'emailIds': emailIds,
        }),
      );

      if (response.statusCode == 201) {
        debugPrint('Team created successfully!');
        //await getAllTeams(); // Optionally, refresh the team list after creation
        notifyListeners();
      } else {
        throw Exception('Failed to create team: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error creating team: $e');
      throw Exception('Error creating team: $e');
    }
  }

  // Function to fetch teams created by the user
  Future<List<dynamic>> getTeamsByUser() async {
    debugPrint("Fetching teams created by user");

    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      final uri = Uri.parse(
          'http://localhost:4000/api/v1/user/userdashboard'); // Update the URI to your endpoint

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Teams fetched successfully!');
        final List<dynamic> teams = jsonDecode(response.body)['teams'];
        return teams;
      } else {
        throw Exception('Failed to fetch teams: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching teams: $e');
      throw Exception('Error fetching teams: $e');
    }
  }
}
