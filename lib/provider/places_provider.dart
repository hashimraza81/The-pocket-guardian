// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class PlacesProvider extends ChangeNotifier {
//   final String apiKey = 'AIzaSyD_CSB5fEb6ad5uRMs1qpmCV6MAgKgN5cE';
//   List<dynamic> suggestions = [];
//   String? selectedLocation;
//   String? userId;

//   void setUserId(String id) {
//     userId = id;
//   }

//   Future<void> fetchSuggestions(String input) async {
//     final String url =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&sessiontoken=1234567890&components=country:pk';

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       suggestions = data['predictions'];
//       notifyListeners();
//     } else {
//       throw Exception('Failed to load suggestions');
//     }
//   }

//   void setSelectedLocation(String location) {
//     selectedLocation = location;
//     notifyListeners();
//   }

//   void clearSelectedLocation() {
//     selectedLocation = null;
//     notifyListeners();
//   }

//   Future<void> fetchInitialLocation() async {
//     if (userId == null) return;

//     final doc = await FirebaseFirestore.instance
//         .collection('trackUsers')
//         .doc(userId)
//         .get();
//     if (doc.exists && doc.data()?['pinLocation'] != null) {
//       selectedLocation = doc.data()?['pinLocation']['description'];
//       notifyListeners();
//     }
//   }

//   Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
//     final String url =
//         'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey';

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       return json.decode(response.body)['result'];
//     } else {
//       throw Exception('Failed to load place details');
//     }
//   }

//   Future<void> savePlaceDetails(String placeId, String description) async {
//     final placeDetails = await fetchPlaceDetails(placeId);

//     final lat = placeDetails['geometry']['location']['lat'];
//     final lng = placeDetails['geometry']['location']['lng'];

//     // Save place details to Firestore
//     if (userId != null) {
//       await FirebaseFirestore.instance
//           .collection('trackUsers')
//           .doc(userId)
//           .update({
//         'pinLocation': {
//           'description': description,
//           'latitude': lat,
//           'longitude': lng,
//         },
//       });
//       setSelectedLocation(description);
//     }
//   }
// }

// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;

// import '../firebase functions/location_service.dart';
// import '../view/To Be Tracked/alert_screen.dart';

// class PlacesProvider extends ChangeNotifier {
//   final String apiKey = 'AIzaSyD_CSB5fEb6ad5uRMs1qpmCV6MAgKgN5cE';
//   List<dynamic> suggestions = [];
//   String? selectedLocation;
//   double? savedLatitude;
//   double? savedLongitude;
//   String? userId;
//   final LocationService _locationService = LocationService();

//   void setUserId(String id) {
//     userId = id;
//   }

//   Future<void> fetchSuggestions(String input) async {
//     final String url =
//         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&sessiontoken=1234567890&components=country:pk';

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> data = json.decode(response.body);
//       suggestions = data['predictions'];
//       notifyListeners();
//     } else {
//       throw Exception('Failed to load suggestions');
//     }
//   }

//   void setSelectedLocation(String location) {
//     selectedLocation = location;
//     notifyListeners();
//   }

//   void clearSelectedLocation() {
//     selectedLocation = null;
//     notifyListeners();
//   }

//   Future<void> fetchInitialLocation() async {
//     if (userId == null) return;

//     final doc = await FirebaseFirestore.instance
//         .collection('trackUsers')
//         .doc(userId)
//         .get();
//     if (doc.exists && doc.data()?['pinLocation'] != null) {
//       selectedLocation = doc.data()?['pinLocation']['description'];
//       savedLatitude = doc.data()?['pinLocation']['latitude'];
//       savedLongitude = doc.data()?['pinLocation']['longitude'];
//       notifyListeners();
//     }
//   }

//   Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
//     final String url =
//         'https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeId&key=$apiKey';

//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       return json.decode(response.body)['result'];
//     } else {
//       throw Exception('Failed to load place details');
//     }
//   }

//   Future<void> savePlaceDetails(String placeId, String description) async {
//     final placeDetails = await fetchPlaceDetails(placeId);

//     final lat = placeDetails['geometry']['location']['lat'];
//     final lng = placeDetails['geometry']['location']['lng'];

//     if (userId != null) {
//       await FirebaseFirestore.instance
//           .collection('trackUsers')
//           .doc(userId)
//           .update({
//         'pinLocation': {
//           'description': description,
//           'latitude': lat,
//           'longitude': lng,
//         },
//       });
//       setSelectedLocation(description);
//       savedLatitude = lat;
//       savedLongitude = lng;
//     }
//   }

//   void startTrackingLocation(BuildContext context) {
//     Geolocator.getPositionStream(
//         locationSettings: const LocationSettings(
//       accuracy: LocationAccuracy.high,
//       distanceFilter: 100,
//     )).listen((Position position) {
//       print(
//           'Current position: ${position.latitude}, ${position.longitude}'); // Debug
//       checkDistanceAndTriggerAlert(position, context);
//     });
//   }

//   void checkDistanceAndTriggerAlert(
//       Position position, BuildContext context) async {
//     if (selectedLocation == null ||
//         savedLatitude == null ||
//         savedLongitude == null) {
//       print('No saved location to compare'); // Debug
//       return;
//     }

//     double distance = Geolocator.distanceBetween(
//           position.latitude,
//           position.longitude,
//           savedLatitude!,
//           savedLongitude!,
//         ) /
//         1000; // distance in km

//     if (distance > 20) {
//       // Trigger alert
//       Navigator.push(
//           context, MaterialPageRoute(builder: (_) => const AlertScreen()));
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../view/To Be Tracked/alert_screen.dart';

class LocationPlacesProvider with ChangeNotifier {
  final String apiKey = 'AIzaSyD_CSB5fEb6ad5uRMs1qpmCV6MAgKgN5cE';
  Position? _currentPosition;
  String? _currentAddress;
  final List<Marker> _markers = [];
  final Completer<GoogleMapController> _completer =
      Completer<GoogleMapController>();
  late StreamSubscription<Position> _positionStreamSubscription;

  String? selectedLocation;
  double? savedLatitude;
  double? savedLongitude;
  String? userId;

  List<dynamic> suggestions = [];
  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  List<Marker> get markers => _markers;
  Completer<GoogleMapController> get completer => _completer;

  void setUserId(String id) {
    userId = id;
  }

  Future<void> fetchInitialLocation() async {
    if (userId == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('trackUsers')
        .doc(userId)
        .get();
    if (doc.exists && doc.data()?['pinLocation'] != null) {
      selectedLocation = doc.data()?['pinLocation']['description'];
      savedLatitude = doc.data()?['pinLocation']['latitude'];
      savedLongitude = doc.data()?['pinLocation']['longitude'];
      print(
          'Initial location fetched: $selectedLocation, $savedLatitude, $savedLongitude'); // Debug
      notifyListeners();
    }
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
      savedLatitude = lat;
      savedLongitude = lng;
    }
  }

  Future<LatLng?> getUserCurrentLocation() async {
    print('hashim 1');
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      _positionStreamSubscription =
          Geolocator.getPositionStream().listen((Position position) async {
        _currentPosition = position;
        _markers.clear();
        _markers.add(Marker(
          markerId: const MarkerId('1'),
          position: LatLng(position.latitude, position.longitude),
        ));

        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        );

        final GoogleMapController controller = await _completer.future;
        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

        // Fetch the address based on the current position
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        print('hashim');
        _currentAddress =
            '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';

        // Save to Firebase
        await saveLocationToFirestore(position);

        notifyListeners();
      });
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<void> saveLocationToFirestore(Position position) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('trackUsers')
          .doc(user.uid)
          .update({
        'live-location': {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        }
      });
    }
  }

  void startTrackingLocation(BuildContext context) {
    Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    )).listen((Position position) {
      print(
          'Current position: ${position.latitude}, ${position.longitude}'); // Debug
      checkDistanceAndTriggerAlert(position, context);
    });
  }

  void checkDistanceAndTriggerAlert(
      Position position, BuildContext context) async {
    if (selectedLocation == null ||
        savedLatitude == null ||
        savedLongitude == null) {
      print('No saved location to compare'); // Debug
      return;
    }

    double distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          savedLatitude!,
          savedLongitude!,
        ) /
        1000; // distance in km

    print('Distance from saved location: $distance km'); // Debug

    if (distance > 20) {
      print('Distance is greater than 20 km, triggering alert'); // Debug
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const AlertScreen()));
    } else {
      print('Distance is less than 20 km, no alert triggered'); // Debug
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }
}
