import 'dart:async';

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

  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  List<Marker> get markers => _markers;
  Completer<GoogleMapController> get completer => _completer;

  Future<void> getUserCurrentLocation() async {
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

      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('1'),
        position:
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ));

      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await _completer.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      // Fetch the address based on the current position
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      _currentAddress =
          '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.administrativeArea}, ${placemarks.first.country}';

      notifyListeners();
    } catch (e) {
      print("Error: $e");
    }
  }
}
