import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventProvider extends ChangeNotifier {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> createEvent(
      String eventName, String location, String imageUrl) async {
    debugPrint(">>>>>>>>>>>>>>>>>>>>> Testing create event");

    try {
      // Retrieve token from SharedPreferences
      final token = await _getToken();

      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // Create the body with only the required values
      final eventData = {
        "eventname": eventName,
        "location": location,
        "image": imageUrl
      };

      // Send the request with the token in the header and the body as JSON
      final response = await http.post(
        Uri.parse(
            'http://localhost:4000/api/v1/user/admindashboard'), // Replace with your backend URL
        headers: {
          'Authorization': 'Bearer $token', // Use the retrieved token
          'Content-Type':
              'application/json', // Indicate we're sending JSON data
        },
        body: json.encode(eventData), // Convert the body to JSON
      );

      if (response.statusCode == 201) {
        debugPrint('Event created successfully!');
      } else {
        throw Exception('Failed to create event: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error creating event: $e');
      throw Exception('Error creating event: $e');
    }
  }

  // Fetch all events
  Future<List<Map<String, dynamic>>> getAllEvents() async {
    try {
      // Retrieve token from SharedPreferences
      final token = await _getToken();

      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      // Make the GET request
      final response = await http.get(
        Uri.parse(
            'http://localhost:4000/api/v1/user/admindashboard'), // Replace with your backend URL
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the header
          'Content-Type': 'application/json', // Ensure JSON response
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final data = json.decode(response.body);
        final List<dynamic> events = data['events'];

        // Convert to a list of maps and return
        return events.map((event) => event as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch events: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
      throw Exception('Error fetching events: $e');
    }
  }

  // Update an existing event
  Future<void> updateEvent(String eventId, String eventName, String location,
      String imageUrl) async {
    debugPrint(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Testing create event");
    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      final eventData = {
        "eventname": eventName,
        "location": location,
        "image": imageUrl,
      };

      final response = await http.patch(
        Uri.parse(
            'http://localhost:4000/api/v1/user/admindashboard/$eventId'), // Replace with your backend URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(eventData),
      );

      if (response.statusCode == 200) {
        debugPrint('Event updated successfully!');
      } else {
        throw Exception('Failed to update event: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error updating event: $e');
      throw Exception('Error updating event: $e');
    }
  }

  // Delete an event
  Future<void> deleteEvent(String eventId) async {
    try {
      final token = await _getToken();

      if (token == null) {
        throw Exception('Authentication token not found. Please login again.');
      }

      final response = await http.delete(
        Uri.parse(
            'http://localhost:4000/api/v1/user/admindashboard/$eventId'), // Replace with your backend URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Event deleted successfully!');
      } else {
        throw Exception('Failed to delete event: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error deleting event: $e');
      throw Exception('Error deleting event: $e');
    }
  }
}
