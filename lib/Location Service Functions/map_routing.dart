// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:google_maps_flutter/google_maps_flutter.dart';


// class MapService {
//   static const String _apiKey = 'AIzaSyDJCuMFtKtjK-VnnF_qGa66iLawVMTwSqY';

//   Future<List<LatLng>> getRouteCoordinates(LatLng origin, LatLng destination) async {
//     final response = await http.get(
//       Uri.parse(
//         'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_apiKey',
//       ),
//     );

//     if (response.statusCode == 200) {
//       final decodedData = json.decode(response.body);
//       print('API Response: $decodedData'); // Log the API response

//       if (decodedData['routes'].isNotEmpty) {
//         final points = decodedData['routes'][0]['overview_polyline']['points'];
//         print('Route Points: $points'); // Log the route points
//         return _convertToLatLng(_decodePoly(points));
//       }
//     } else {
//       print('Error fetching route: ${response.statusCode}');
//     }

//     return [];
//   }

//   List<LatLng> _convertToLatLng(List<dynamic> points) {
//     return points.map((point) => LatLng(point[0], point[1])).toList();
//   }

//   List<dynamic> _decodePoly(String poly) {
//     var list = poly.codeUnits;
//     var lList = [];
//     int index = 0;
//     int len = poly.length;
//     int c = 0;

//     do {
//       var shift = 0;
//       int result = 0;

//       do {
//         c = list[index] - 63;
//         result |= (c & 0x1F) << (shift * 5);
//         index++;
//         shift++;
//       } while (c >= 32);

//       if (result & 1 == 1) {
//         result = ~result;
//       }
//       var result1 = (result >> 1) * 0.00001;
//       lList.add(result1);
//     } while (index < len);

//     for (var i = 2; i < lList.length; i++) {
//       lList[i] += lList[i - 2];
//     }

//     return lList;
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';



class MapService {
  static const String _apiKey = 'AIzaSyDJCuMFtKtjK-VnnF_qGa66iLawVMTwSqY';

  Future<List<LatLng>> getRouteCoordinates(LatLng origin, LatLng destination) async {
    final response = await http.get(
      Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      print('API Response: $decodedData'); // Log the API response

      if (decodedData['routes'].isNotEmpty) {
        final points = decodedData['routes'][0]['overview_polyline']['points'];
        print('Route Points: $points'); // Log the route points
        return _decodePoly(points);
      }
    } else {
      print('Error fetching route: ${response.statusCode}');
    }

    return [];
  }

  List<LatLng> _decodePoly(String poly) {
    List<LatLng> polyline = [];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      polyline.add(p);
    }

    return polyline;
  }
}
