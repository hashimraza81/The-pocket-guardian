import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/provider/tracking_bottom_bar_Provider.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../Location Service Functions/map_routing.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
 // Assuming map_service.dart contains MapService class

class LiveTracking extends StatefulWidget {
  final double? currentPersonLat;
  final double? currentPersonLng;
  final double? userLat;
  final double? userLng;

  const LiveTracking({
    Key? key,
     this.currentPersonLat,
    this.currentPersonLng,
    this.userLat,
     this.userLng,
  }) : super(key: key);

  @override
  _LiveTrackingState createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  late GoogleMapController mapController;
  final MapService _mapService = MapService();
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _fetchRoute();
  }

  Future<void> _fetchRoute() async {
    LatLng currentPersonLatLng = LatLng(widget.currentPersonLat!, widget.currentPersonLng!);
    LatLng userLatLng = LatLng(widget.userLat!, widget.userLng!);

    polylineCoordinates = await _mapService.getRouteCoordinates(
      currentPersonLatLng,
      userLatLng,
    );

    if (polylineCoordinates.isNotEmpty) {
      print('Polyline Coordinates: $polylineCoordinates'); // Log the coordinates
      setState(() {
        polylines.add(
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 6,
          ),
        );
      });
    } else {
      print('No polyline coordinates found');
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng currentPersonLatLng = LatLng(widget.currentPersonLat!, widget.currentPersonLng!);
    LatLng userLatLng = LatLng(widget.userLat!, widget.userLng!);

    return ChangeNotifierProvider(
      create: (context) => TrackingBottomBarProvider(),
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Live Tracking',
              style: TextStyle(
                fontSize: 24.0,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
          body: GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: currentPersonLatLng,
              zoom: 14.0,
            ),
            polylines: polylines,
            markers: {
              Marker(
                markerId: MarkerId('currentLocation'),
                position: currentPersonLatLng,
              ),
              Marker(
                markerId: MarkerId('userLocation'),
                position: userLatLng,
              ),
            },
          ),
          bottomNavigationBar: TrackingBottomBar(),
        ),
      ),
    );
  }
}
