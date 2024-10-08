import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  Position? _currentPosition;
  String? _currentAddress;
  final List<Marker> _markers = [];
  final Completer<GoogleMapController> _completer =
      Completer<GoogleMapController>();
  late StreamSubscription<Position> _positionStreamSubscription;

  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  List<Marker> get markers => _markers;
  Completer<GoogleMapController> get completer => _completer;

  Future<LatLng?> getUserCurrentLocation() async {
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
          position.latitude,
          position.longitude,
        );

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

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }
}
