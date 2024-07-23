import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlacesProvider extends ChangeNotifier {
  final String apiKey = 'AIzaSyD_CSB5fEb6ad5uRMs1qpmCV6MAgKgN5cE';
  List<dynamic> suggestions = [];
  String? selectedLocation;
  String? userId;

  void setUserId(String id) {
    userId = id;
  }

  Future<void> fetchSuggestions(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&sessiontoken=1234567890&components=country:pk';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      suggestions = data['predictions'];
      notifyListeners();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  void setSelectedLocation(String location) {
    selectedLocation = location;
    notifyListeners();
  }

  void clearSelectedLocation() {
    selectedLocation = null;
    notifyListeners();
  }

  Future<void> fetchInitialLocation() async {
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('trackUsers')
        .doc(userId)
        .get();
    if (doc.exists && doc.data()?['pinLocation'] != null) {
      selectedLocation = doc.data()?['pinLocation']['description'];
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body)['result'];
    } else {
      throw Exception('Failed to load place details');
    }
  }

  Future<void> savePlaceDetails(String placeId, String description) async {
    final placeDetails = await fetchPlaceDetails(placeId);

    final lat = placeDetails['geometry']['location']['lat'];
    final lng = placeDetails['geometry']['location']['lng'];

    // Save place details to Firestore
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('trackUsers')
          .doc(userId)
          .update({
        'pinLocation': {
          'description': description,
          'latitude': lat,
          'longitude': lng,
        },
      });
      setSelectedLocation(description);
    }
  }
}
