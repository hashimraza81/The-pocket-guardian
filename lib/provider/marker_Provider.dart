import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerProvider with ChangeNotifier {
  final Set<Marker> _markers = {};

  Set<Marker> get markers => _markers;

  void addMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }
}
