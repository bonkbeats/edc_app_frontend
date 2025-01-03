import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PublicEventProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _noResultsFound = false; // Flag to track if no results are found

  List<Map<String, dynamic>> get events =>
      _isSearching ? _searchResults : _events;

  bool get noResultsFound => _noResultsFound;

  // Fetch all events from the server
  Future<void> fetchAllEvents() async {
    const url =
        'https://edc-app-vt8t.onrender.com/api/v1/publicevent'; // Replace with your backend URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        _events = List<Map<String, dynamic>>.from(decodedData['events']);
        _isSearching = false; // Reset searching state
        _noResultsFound = false; // Reset the no results flag
        notifyListeners();
      } else {
        throw Exception('Failed to fetch events');
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
      throw Exception('Error fetching events: $e');
    }
  }

  // Search for events by name
  Future<void> searchEvents(String query) async {
    if (query.isEmpty) {
      _isSearching = false;
      _searchResults = []; // Clear search results
      _noResultsFound = false; // Reset the no results flag
      notifyListeners();
      return;
    }

    final url =
        'https://edc-app-vt8t.onrender.com/api/v1/publicevent/search?name=$query';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        _searchResults = List<Map<String, dynamic>>.from(decodedData);

        if (_searchResults.isEmpty) {
          _noResultsFound = true; // Set flag when no results are found
        } else {
          _noResultsFound = false; // Reset flag when results are found
        }

        _isSearching = true; // Update search state
        notifyListeners();
      } else {
        throw Exception('Failed to search events');
      }
    } catch (e) {
      debugPrint('Error searching events: $e');
      throw Exception('Error searching events: $e');
    }
  }
}
