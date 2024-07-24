import 'dart:math';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Function to get address from latitude and longitude
  Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address = "${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}";
        return address;
      } else {
        return "No address available";
      }
    } catch (e) {
      print(e);
      return "Error retrieving address";
    }
  }

  // Other utility functions can be added here in the future
  // Example function to calculate distance between two coordinates
  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
     double p = 0.017453292519943295; // Math.PI / 180
   double c = 0.5 - cos((endLat - startLat) * p) / 2 + cos(startLat * p) * cos(endLat * p) * (1 - cos((endLng - startLng) * p)) / 2;
    return 12742 * asin(sqrt(c)); // 2 * R; R = 6371 km
  }


  // Function to get the current location
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return an error.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, return an error.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can fetch the current location.
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
