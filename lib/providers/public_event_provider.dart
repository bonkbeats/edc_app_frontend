import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PublicEventProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _events = [];

  List<Map<String, dynamic>> get events => _events;

  Future<void> fetchAllEvents() async {
    // 192.168.43.189
    //http://localhost:4000/api/v1/publicevent
    const url =
        'http://192.168.43.189:4000/api/v1/publicevent'; // Replace with your backend URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        _events = List<Map<String, dynamic>>.from(decodedData['events']);
        notifyListeners();
      } else {
        throw Exception('Failed to fetch events');
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
      throw Exception('Error fetching events: $e');
    }
  }
}
