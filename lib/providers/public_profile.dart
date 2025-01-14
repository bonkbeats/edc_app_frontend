import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PublicProfileProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _profiles = [];
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  bool _noResultsFound = false;

  List<Map<String, dynamic>> get profiles =>
      _isSearching ? _searchResults : _profiles;

  bool get noResultsFound => _noResultsFound;

  // Corrected typo in method name to 'fetchAllProfiles'
  Future<void> fetchAllProfiles() async {
    const url = 'https://edc-app-osf6.onrender.com/api/v1/publicevent/profile';

    try {
      final response = await http.get(Uri.parse(url));

      // Debugging: print the raw response body
      debugPrint('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final decodeData = json.decode(response.body);

        // Debugging: print the decoded data
        debugPrint('Decoded data: $decodeData');

        // Ensure that decodeData['profiles'] is a list
        if (decodeData['profiles'] is List) {
          _profiles = List<Map<String, dynamic>>.from(decodeData['profiles']);
        } else {
          _profiles = [];
        }

        _isSearching = false; // Reset searching state
        _noResultsFound = false;
        debugPrint('Fetched profiles: $_profiles');
        notifyListeners();
      } else {
        throw Exception('Failed to fetch profiles');
      }
    } catch (e) {
      throw Exception('Error fetching profiles: $e');
    }
  }

  Future<void> searchProfile(String query) async {
    if (query.isEmpty) {
      _isSearching = false;
      _searchResults = [];
      _noResultsFound = false;
      notifyListeners();
      return;
    }

    final url =
        'https://edc-app-osf6.onrender.com/api/v1/publicevent/profile/search?name=${Uri.encodeQueryComponent(query)}';
    debugPrint('Search URL: $url'); // Check the URL being used

    try {
      final response = await http.get(Uri.parse(url));
      debugPrint(
          '>>>>>>>>>>>>>>>>>>>>>>>>>Response status: ${response.statusCode}');
      // debugPrint('Response body: ${response.body}'); // Log the raw response

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        // debugPrint('Decoded data: $decodedData'); // Check decoded data

        if (decodedData is List) {
          _searchResults = List<Map<String, dynamic>>.from(decodedData);
        } else {
          _searchResults = [];
        }

        _noResultsFound = _searchResults.isEmpty;
        _isSearching = true;
        notifyListeners();
      } else {
        throw Exception('Failed to search profiles');
      }
    } catch (e) {
      debugPrint('Error searching profiles: $e');
      throw Exception('Error searching profiles: $e');
    }
  }
}
