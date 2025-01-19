import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EdcTeamProvider extends ChangeNotifier {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> updateProfile(
    String profileId,
    String name,
    String position,
    File? imageFile,
  ) async {
    debugPrint(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Testing update PROFILE");

    try {
      // Retrieve token from SharedPreferences
      final token = await _getToken();

      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // Prepare URI
      final uri = Uri.parse(
          'http://157.245.107.86:4000/api/v1/user/admindashboard/profile/$profileId'); // Replace with your backend URL

      // Create multipart request
      var request = http.MultipartRequest('PATCH', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = name
        ..fields['position'] = position;

      // debugPrint("organiser: $organiser");
      // debugPrint("location: $location");
      // debugPrint("eventDay: $eventDay");

      // If image is provided, add it to the request
      if (imageFile != null) {
        // Add the image file to the request
        var imageFileBytes = await imageFile.readAsBytes();
        var multipartFile = http.MultipartFile.fromBytes(
          'image', // The field name on the server (e.g., 'image' for file upload)
          imageFileBytes,
          filename: imageFile.uri.pathSegments.last, // File name from the image
        );
        request.files.add(multipartFile);
      }

      // Send the request
      final response = await request.send();

      // Check response status
      if (response.statusCode == 200) {
        debugPrint('Event updated successfully!');
        await getAllProfiles();
        notifyListeners();
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to update profile: $responseBody');
      }
    } catch (e) {
      debugPrint('Error updating event: $e');
      throw Exception('Error updating event: $e');
    }
  }

  // Function to create a new profile
  Future<void> createProfile(
    String name,
    String position,
    File? imageFile,
  ) async {
    debugPrint(">>>>>>>>>>>>>>>>>>>>> Testing create profile");

    try {
      // Retrieve token from SharedPreferences
      final token = await _getToken();

      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // Prepare URI for the profile creation endpoint
      final uri = Uri.parse(
          'http://157.245.107.86:4000/api/v1/user/admindashboard/profile'); // Replace with your backend URL

      // Create multipart request
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['name'] = name
        ..fields['position'] = position;

      // Debug: Print the form data before sending
      debugPrint('Sending data: Name = $name, Position = $position');

      // If image is provided, add it to the request
      if (imageFile != null) {
        // Add the image file to the request
        var imageFileBytes = await imageFile.readAsBytes();
        var multipartFile = http.MultipartFile.fromBytes(
          'image', // The field name on the server (e.g., 'image' for file upload)
          imageFileBytes,
          filename: imageFile.uri.pathSegments.last, // File name from the image
        );
        request.files.add(multipartFile);
      }

      // Send the request
      final response = await request.send();

      // Check response status
      if (response.statusCode == 201) {
        debugPrint('Profile created successfully!');
        // Optionally, refresh or fetch the updated list of profiles after creating one
        await getAllProfiles();
        notifyListeners();
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to create profile: $responseBody');
      }
    } catch (e) {
      debugPrint('Error creating profile: $e');
      throw Exception('Error creating profile: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    try {
      // Retrieve token from SharedPreferences
      final token = await _getToken();

      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // Make the GET request
      final response = await http.get(
        Uri.parse(
            'http://157.245.107.86:4000/api/v1/user/admindashboard/profile'), // Replace with your backend URL
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the header
          'Content-Type': 'application/json', // Ensure JSON response
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final data = json.decode(response.body);
        final List<dynamic> profiles = data['profiles'];

        // Convert to a list of maps and return
        return profiles
            .map((profile) => profile as Map<String, dynamic>)
            .toList();
      } else {
        throw Exception('Failed to fetch profile: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching profiles: $e');
      throw Exception('Error fetching  profiles: $e');
    }
  }

  // Function to delete a profile
  Future<void> deleteProfile(String profileId) async {
    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      final response = await http.delete(
        Uri.parse(
            'http://157.245.107.86:4000/api/v1/user/admindashboard/profile/$profileId'), // Replace with your backend URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Profile deleted successfully!');
        await getAllProfiles(); // Optionally, refresh the profile list after deletion
        notifyListeners();
      } else {
        throw Exception('Failed to delete profile: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error deleting profile: $e');
      throw Exception('Error deleting profile: $e');
    }
  }
}
