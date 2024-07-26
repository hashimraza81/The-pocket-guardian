import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/location_Provider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/view/Tracking/live_tracking.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../Location Service Functions/location_services.dart';

class TrackingLocation extends StatefulWidget {
  final double? lat;
  final double? lng;
  final String? imageUrl;
  final bool? fromNotificationRoute;

  const TrackingLocation({
    Key? key,
    this.lat,
    this.lng,
    this.imageUrl,
    this.fromNotificationRoute,
  }) : super(key: key);

  @override
  _TrackingLocationState createState() => _TrackingLocationState();
}

class _TrackingLocationState extends State<TrackingLocation> {
  CameraPosition? _initialCameraPosition;
  bool _showOverlayImage = false;
  String _address = "Loading...";
  double? _distance;
  Position? position;
  Set<Marker> _markers = {};

  Future<void> _fetchAddress() async {
    LocationService locationService = LocationService();

    try {
      position = await locationService.getCurrentLocation();
      String address = widget.fromNotificationRoute == true
          ? await locationService.getAddressFromLatLng(widget.lat!, widget.lng!)
          : await locationService.getAddressFromLatLng(position!.latitude, position!.longitude);
      if (widget.fromNotificationRoute == true) {
        double distance = locationService.calculateDistance(
          position!.latitude, position!.longitude, widget.lat!, widget.lng!);
        setState(() {
          _distance = distance;
        });
      }
      setState(() {
        _address = address;
        _initialCameraPosition = widget.fromNotificationRoute == true
          ? CameraPosition(
              target: LatLng(widget.lat!, widget.lng!),
              zoom: 14.4746,
            )
          : CameraPosition(
              target: LatLng(position!.latitude, position!.longitude),
              zoom: 14.4746,
            );
        _markers = {
          Marker(
            markerId: MarkerId('currentLocation'),
            position: widget.fromNotificationRoute == true
                ? LatLng(widget.lat!, widget.lng!)
                : LatLng(position!.latitude, position!.longitude),
            infoWindow: InfoWindow(
              title: widget.fromNotificationRoute == true
                  ? 'Notification Location'
                  : 'Current Location',
            ),
          ),
        };
      });
    } catch (e) {
      setState(() {
        _address = "Error fetching address: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 44.0,
              width: 44.0,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.primary,
              ),
            ),
          ),
          title: CustomText(
            text: 'location',
            size: 24.0,
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            familyFont: 'Montserrat',
          ),
        ),
        body: Stack(
          children: [
            // Map Placeholder
            Positioned.fill(
              child: _initialCameraPosition == null
                  ? Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      initialCameraPosition: _initialCameraPosition!,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      compassEnabled: false,
                      onMapCreated: (GoogleMapController controller) {
                        if (!locationProvider.completer.isCompleted) {
                          locationProvider.completer.complete(controller);
                        }
                      },
                      markers: _markers,
                    ),
            ),
            // GPS Location Pin
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon(
                  //   Icons.location_on,
                  //   size: 50,
                  //   color: AppColors.secondary,
                  // ),
                ],
              ),
            ),
            // User Information and Buttons
            Padding(
              padding: EdgeInsets.only(top: 560),
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
                  child: CustomText(
                    text: 'Click here to allow location access for better safety',
                    size: 12,
                    fontWeight: FontWeight.w500,
                    familyFont: 'Montserrat',
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage: widget.imageUrl != null
                                  ? NetworkImage(widget.imageUrl!)
                                  : null,
                              child: widget.imageUrl == null
                                  ? Icon(Icons.person, size: 30.0)
                                  : null,
                            ),
                            SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MON 24, MAY • 10:00 AM',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat',
                                      color: AppColors.grey3,
                                    ),
                                  ),
                                  Text(
                                    _address,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat',
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  if (_distance != null)
                                    Text(
                                      "Distance: ${_distance!.toStringAsFixed(2)} km",
                                      style: TextStyle(
                                        fontSize: 8.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Montserrat',
                                        color: const Color(0xFF000000),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                AppImages.refresh,
                                color: AppColors.secondary,
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        if (widget.fromNotificationRoute == true)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(AppColors.white),
                                  side: MaterialStateProperty.all(
                                    const BorderSide(color: AppColors.grey4, width: 1),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LiveTracking(
                                        currentPersonLat: position!.latitude,
                                        currentPersonLng: position!.longitude,
                                        userLat: widget.lat!,
                                        userLng: widget.lng!,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(AppImages.watch),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Watch',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat',
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _showOverlayImage = !_showOverlayImage;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.red,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(AppImages.contact),
                                    SizedBox(width: 8.0),
                                    Text(
                                      'Contact',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat',
                                        color: AppColors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  if (_showOverlayImage)
                    Positioned.fill(
                      child: Container(
                        width: double.infinity,
                        color: AppColors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: [
                              ReusedButton(
                                text: 'Message',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                colorbg: AppColors.secondary.withOpacity(0.2),
                                bordercolor: AppColors.secondary,
                                colortext: AppColors.primary,
                              ),
                              SizedBox(height: 15.0),
                              ReusedButton(
                                text: 'Call',
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                colorbg: AppColors.secondary.withOpacity(0.2),
                                bordercolor: AppColors.secondary,
                                colortext: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class TrackingLocation extends StatefulWidget {
//   final double? lat;
//   final double? lng;
//   final String? imageUrl;
//   final bool? fromNotificationRoute;

//   const TrackingLocation({
//     Key? key,
//     this.lat,
//     this.lng,
//     this.imageUrl,
//     this.fromNotificationRoute,
//   }) : super(key: key);

//   @override
//   _TrackingLocationState createState() => _TrackingLocationState();
// }

// class _TrackingLocationState extends State<TrackingLocation> {
//   CameraPosition? _initialCameraPosition;
//   bool _showOverlayImage = false;
//   String _address = "Loading...";
//   double? _distance;
//   Position? position;
//   Set<Marker> _markers = {};

//   Future<void> _fetchAddress() async {
//     LocationService locationService = LocationService();

//     try {
//       position = await locationService.getCurrentLocation();
//       String address = await locationService.getAddressFromLatLng(
//         widget.fromNotificationRoute == true
//             ? widget.lat!
//             : position!.latitude,
//         widget.fromNotificationRoute == true
//             ? widget.lng!
//             : position!.longitude,
//       );
//       double distance = widget.lat != null && widget.lng != null
//           ? locationService.calculateDistance(
//               position!.latitude, position!.longitude, widget.lat!, widget.lng!)
//           : 0.0;

//       setState(() {
//         _address = address;
//         _distance = distance;
//         _initialCameraPosition = CameraPosition(
//           target: LatLng(
//             widget.fromNotificationRoute == true
//                 ? position!.latitude
//                 : widget.lat!,
//             widget.fromNotificationRoute == true
//                 ? position!.longitude
//                 : widget.lng!,
//           ),
//           zoom: 14.4746,
//         );
//         _markers.add(
//           Marker(
//             markerId: MarkerId('currentLocation'),
//             position: LatLng(
//               widget.fromNotificationRoute == true
//                   ? position!.latitude
//                   : widget.lat!,
//               widget.fromNotificationRoute == true
//                   ? position!.longitude
//                   : widget.lng!,
//             ),
//             infoWindow: InfoWindow(
//               title: 'Current Location',
//             ),
//           ),
//         );
//       });
//     } catch (e) {
//       setState(() {
//         _address = "Error fetching address: $e";
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _fetchAddress();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final locationProvider = Provider.of<LocationProvider>(context);
//     return SafeArea(
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           automaticallyImplyLeading: false,
//           elevation: 0,
//           centerTitle: true,
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Container(
//               height: 44.0,
//               width: 44.0,
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: const Icon(
//                 Icons.arrow_back_ios,
//                 color: AppColors.primary,
//               ),
//             ),
//           ),
//           title: CustomText(
//             text: 'location',
//             size: 24.0,
//             color: AppColors.primary,
//             fontWeight: FontWeight.w700,
//             familyFont: 'Montserrat',
//           ),
//         ),
//         body: Stack(
//           children: [
//             // Map Placeholder
//             Positioned.fill(
//               child: _initialCameraPosition == null
//                   ? Center(child: CircularProgressIndicator())
//                   : GoogleMap(
//                       initialCameraPosition: _initialCameraPosition!,
//                       mapType: MapType.normal,
//                       myLocationEnabled: true,
//                       compassEnabled: false,
//                       onMapCreated: (GoogleMapController controller) {
//                         if (!locationProvider.completer.isCompleted) {
//                           locationProvider.completer.complete(controller);
//                         }
//                       },
//                       markers: _markers,
//                     ),
//             ),
//             // GPS Location Pin
//             const Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.location_on,
//                     size: 50,
//                     color: AppColors.secondary,
//                   ),
//                 ],
//               ),
//             ),
//             // User Information and Buttons
//             Padding(
//               padding: EdgeInsets.only(top: 560),
//               child: Container(
//                 width: double.infinity,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: AppColors.secondary,
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
//                   child: CustomText(
//                     text: 'Click here to allow location access for better safety',
//                     size: 12,
//                     fontWeight: FontWeight.w500,
//                     familyFont: 'Montserrat',
//                     color: AppColors.white,
//                   ),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: Stack(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(20.0),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 10.0,
//                           offset: const Offset(0, -2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 30.0,
//                               backgroundImage: widget.imageUrl != null
//                                   ? NetworkImage(widget.imageUrl!)
//                                   : null,
//                               child: widget.imageUrl == null
//                                   ? Icon(Icons.person, size: 30.0)
//                                   : null,
//                             ),
//                             SizedBox(width: 10.0),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'MON 24, MAY • 10:00 AM',
//                                     style: TextStyle(
//                                       fontSize: 12.0,
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: 'Montserrat',
//                                       color: AppColors.grey3,
//                                     ),
//                                   ),
//                                   Text(
//                                     _address,
//                                     style: TextStyle(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.w600,
//                                       fontFamily: 'Montserrat',
//                                       color: AppColors.primary,
//                                     ),
//                                   ),
//                                   if (_distance != null)
//                                     Text(
//                                       "Distance: ${_distance!.toStringAsFixed(2)} km",
//                                       style: TextStyle(
//                                         fontSize: 8.0,
//                                         fontWeight: FontWeight.w400,
//                                         fontFamily: 'Montserrat',
//                                         color: const Color(0xFF000000),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {},
//                               child: SvgPicture.asset(
//                                 AppImages.refresh,
//                                 color: AppColors.secondary,
//                                 height: 30,
//                                 width: 30,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 10.0),
//                         if (widget.fromNotificationRoute == true)
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               ElevatedButton(
//                                 style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all(AppColors.white),
//                                   side: MaterialStateProperty.all(
//                                     const BorderSide(color: AppColors.grey4, width: 1),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => LiveTracking(
//                                         currentPersonLat: position!.latitude,
//                                         currentPersonLng: position!.longitude,
//                                         userLat: widget.lat!,
//                                         userLng: widget.lng!,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SvgPicture.asset(AppImages.watch),
//                                     SizedBox(width: 8.0),
//                                     Text(
//                                       'Watch',
//                                       style: TextStyle(
//                                         fontSize: 14.0,
//                                         fontWeight: FontWeight.w600,
//                                         fontFamily: 'Montserrat',
//                                         color: AppColors.primary,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _showOverlayImage = !_showOverlayImage;
//                                   });
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: AppColors.red,
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     SvgPicture.asset(AppImages.contact),
//                                     SizedBox(width: 8.0),
//                                     Text(
//                                       'Contact',
//                                       style: TextStyle(
//                                         fontSize: 14.0,
//                                         fontWeight: FontWeight.w600,
//                                         fontFamily: 'Montserrat',
//                                         color: AppColors.white,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                       ],
//                     ),
//                   ),
//                   if (_showOverlayImage)
//                     Positioned.fill(
//                       child: Container(
//                         width: double.infinity,
//                         color: AppColors.white,
//                         child: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             children: [
//                               ReusedButton(
//                                 text: 'Message',
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 colorbg: AppColors.secondary.withOpacity(0.2),
//                                 bordercolor: AppColors.secondary,
//                                 colortext: AppColors.primary,
//                               ),
//                               SizedBox(height: 15.0),
//                               ReusedButton(
//                                 text: 'Call',
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 colorbg: AppColors.secondary.withOpacity(0.2),
//                                 bordercolor: AppColors.secondary,
//                                 colortext: AppColors.primary,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

