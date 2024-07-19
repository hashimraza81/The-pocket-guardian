import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class PinLocation extends StatefulWidget {
  const PinLocation({super.key});

  @override
  State<PinLocation> createState() => _PinLocationState();
}

class _PinLocationState extends State<PinLocation> {
  final TextEditingController _controller = TextEditingController();
  var uuid = const Uuid();
  final String _sessionToken = const Uuid().v4();
  List<dynamic> _placesList = [];
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      onChanged();
    });
  }

  void onChanged() {
    if (_controller.text.isNotEmpty) {
      getSuggestion(_controller.text);
    } else {
      setState(() {
        _placesList = [];
      });
    }
  }

  void getSuggestion(String input) async {
    String kPlacesApiKey = 'AIzaSyD_CSB5fEb6ad5uRMs1qpmCV6MAgKgN5cE';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPlacesApiKey&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void getPlaceDetails(String placeId, String description) async {
    String kPlacesApiKey = 'YOUR_API_KEY';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
    String request = '$baseURL?place_id=$placeId&key=$kPlacesApiKey';

    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      var placeDetails = jsonDecode(response.body);
      var location = placeDetails['result']['geometry']['location'];
      double lat = location['lat'];
      double lng = location['lng'];

      await saveLocationToFirebase(lat, lng, description);
    } else {
      throw Exception('Failed to load place details');
    }
  }

  Future<void> saveLocationToFirebase(
      double lat, double lng, String description) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot trackUserDoc = await FirebaseFirestore.instance
          .collection('trackUsers')
          .doc(user.uid)
          .get();

      if (trackUserDoc.exists) {
        CollectionReference users =
            FirebaseFirestore.instance.collection('trackUsers');

        await users.doc(user.uid).update({
          'location': {
            'latitude': lat,
            'longitude': lng,
            'description': description,
          }
        });

        setState(() {
          _selectedLocation = description;
          _placesList = [];
          _controller.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Location saved successfully'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('User is not in trackUsers collection'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('User not logged in'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _selectedLocation != null
            ? ListTile(
                title: Text(_selectedLocation!),
                trailing: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _selectedLocation = null;
                    });
                  },
                ),
              )
            : TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Search The Place As Home',
                ),
              ),
        const SizedBox(height: 10),
        SizedBox(
          height: 62,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _placesList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_placesList[index]['description']),
                onTap: () {
                  String placeId = _placesList[index]['place_id'];
                  String description = _placesList[index]['description'];
                  getPlaceDetails(placeId, description);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
