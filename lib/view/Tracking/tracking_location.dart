import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/provider/location_Provider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

// class TrackingLocation extends StatefulWidget {
//   const TrackingLocation({super.key});

//   @override
//   _TrackingLocationState createState() => _TrackingLocationState();
// }

// class _TrackingLocationState extends State<TrackingLocation> {
//   static const CameraPosition kGooglePlex = CameraPosition(
//     target: LatLng(33.516842, 73.086052),
//     zoom: 14.4746,
//   );
//   bool _showOverlayImage = false;

//   @override
//   Widget build(BuildContext context) {
//     final locationProvider = Provider.of<LocationProvider>(context);
//     return SafeArea(
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             automaticallyImplyLeading: false,
//             elevation: 0,
//             centerTitle: true,
//             leading: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Container(
//                 height: 44.0.h,
//                 width: 44.0.w,
//                 decoration: BoxDecoration(
//                   color: AppColors.white,
//                   borderRadius: BorderRadius.circular(
//                     10.0.r,
//                   ),
//                 ),
//                 child: const Icon(
//                   Icons.arrow_back_ios,
//                   color: AppColors.primary,
//                 ),
//               ),
//             ),
//             title: CustomText(
//               text: 'location',
//               size: 24.0.sp,
//               color: AppColors.primary,
//               fontWeight: FontWeight.w700,
//               familyFont: 'Montserrat',
//             )),
//         body: Stack(
//           children: [
//             // Map Placeholder
//             Positioned.fill(
//               child: GoogleMap(
//                 initialCameraPosition: kGooglePlex,
//                 mapType: MapType.normal,
//                 myLocationEnabled: true,
//                 compassEnabled: false,
//                 onMapCreated: (GoogleMapController controller) {
//                   if (!locationProvider.completer.isCompleted) {
//                     locationProvider.completer.complete(controller);
//                   }
//                 },
//                 markers: Set<Marker>.of(locationProvider.markers),
//               ),
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
//               padding: EdgeInsets.only(
//                 top: 560.h,
//               ),
//               child: Container(
//                 width: double.infinity,
//                 height: 60.h,
//                 decoration: BoxDecoration(
//                   color: AppColors.secondary,
//                   borderRadius: BorderRadius.circular(20.0.r),
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: 28.0.w, vertical: 10.0.h),
//                   child: CustomText(
//                     text:
//                         'Click here to allow location access for better safety',
//                     size: 12.sp,
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
//                         top: Radius.circular(20.0.r),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 10.0.r,
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
//                               // User profile image
//                               radius: 30.0.r,
//                               child: ClipOval(
//                                 child: Image.asset(AppImages.profile),
//                               ),
//                             ),
//                             10.0.pw,
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'MON 24, MAY • 10:00 AM',
//                                     style: TextStyle(
//                                       fontSize: 12.0.sp,
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: 'Montserrat',
//                                       color: AppColors.grey3,
//                                     ),
//                                   ),
//                                   Text(
//                                     '6391 Elgin St. Celina, Island Delaware 10299',
//                                     style: TextStyle(
//                                       fontSize: 16.0.sp,
//                                       fontWeight: FontWeight.w600,
//                                       fontFamily: 'Montserrat',
//                                       color: AppColors.primary,
//                                     ),
//                                   ),
//                                   Text(
//                                     '21.5km away',
//                                     style: TextStyle(
//                                       fontSize: 8.0.sp,
//                                       fontWeight: FontWeight.w400,
//                                       fontFamily: 'Montserrat',
//                                       color: const Color(0xFF000000),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {},
//                               child: SvgPicture.asset(
//                                 AppImages.refresh,
//                                 color: AppColors.secondary,
//                                 height: 30.h,
//                                 width: 30.w,
//                               ),
//                             ),
//                           ],
//                         ),
//                         10.0.ph,
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             ElevatedButton(
//                               style: ButtonStyle(
//                                 backgroundColor:
//                                     WidgetStateProperty.all(AppColors.white),
//                                 side: WidgetStateProperty.all(
//                                   const BorderSide(
//                                       color: AppColors.grey4, width: 1),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Navigator.pushNamed(
//                                     context, RoutesName.livetracking);
//                               },
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   SvgPicture.asset(AppImages.watch),
//                                   8.0.pw,
//                                   Text(
//                                     'Watch',
//                                     style: TextStyle(
//                                       fontSize: 14.0.sp,
//                                       fontWeight: FontWeight.w600,
//                                       fontFamily: 'Montserrat',
//                                       color: AppColors.primary,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   _showOverlayImage = !_showOverlayImage;
//                                 });
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: AppColors.red,
//                               ),
//                               child: Row(
//                                 children: [
//                                   SvgPicture.asset(AppImages.contact),
//                                   8.0.pw,
//                                   Text(
//                                     'Contact',
//                                     style: TextStyle(
//                                       fontSize: 14.0.sp,
//                                       fontWeight: FontWeight.w600,
//                                       fontFamily: 'Montserrat',
//                                       color: AppColors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
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
//                               15.0.ph,
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
class TrackingLocation extends StatefulWidget {
  final double? lat;
  final double? lng;

  const TrackingLocation({
    super.key,
    this.lat,
    this.lng,
  });

  @override
  _TrackingLocationState createState() => _TrackingLocationState();
}

class _TrackingLocationState extends State<TrackingLocation> {
  late CameraPosition _initialCameraPosition;
  bool _showOverlayImage = false;

  loc.LocationData? _currentLocation;
  final loc.Location _location = loc.Location();

  @override
  void initState() {
    super.initState();
    if (widget.lat == null || widget.lng == null) {
      _getCurrentLocation();
    } else {
      _initialCameraPosition = CameraPosition(
        target: LatLng(widget.lat!, widget.lng!),
        zoom: 14.4746,
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await _location.getLocation();
      setState(() {
        _initialCameraPosition = CameraPosition(
          target:
              LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!),
          zoom: 14.4746,
        );
      });
    } catch (e) {
      print("Error obtaining current location: $e");
    }
  }
  // @override
  // void initState() {
  //   print(widget.lat!);
  //   super.initState();
  //   _initialCameraPosition = CameraPosition(
  //     target: LatLng(widget.lat!, widget.lng!),
  //     zoom: 14.4746,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    bool hasLatLng = widget.lat != null && widget.lng != null;
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
            )),
        body: Stack(
          children: [
            // Map Placeholder
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: _initialCameraPosition,
                mapType: MapType.normal,
                myLocationEnabled: true,
                compassEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  if (!locationProvider.completer.isCompleted) {
                    locationProvider.completer.complete(controller);
                  }
                },
                markers: Set<Marker>.of(locationProvider.markers),
              ),
            ),
            // GPS Location Pin
            // const Center(
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Icon(
            //         Icons.location_on,
            //         size: 50,
            //         color: AppColors.secondary,
            //       ),
            //     ],
            //   ),
            // ),
            // // User Information and Buttons
            // Padding(
            //   padding: const EdgeInsets.only(top: 560),
            //   child: Container(
            //     width: double.infinity,
            //     height: 60,
            //     decoration: BoxDecoration(
            //       color: AppColors.secondary,
            //       borderRadius: BorderRadius.circular(20.0),
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(
            //           horizontal: 28.0, vertical: 10.0),
            //       child: CustomText(
            //         text:
            //             'Click here to allow location access for better safety',
            //         size: 12,
            //         fontWeight: FontWeight.w500,
            //         familyFont: 'Montserrat',
            //         color: AppColors.white,
            //       ),
            //     ),
            //   ),
            // ),
            if (hasLatLng)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10.0,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                // User profile image
                                radius: 30.0,
                                child: ClipOval(
                                  child: Image.asset(AppImages.profile),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              const Expanded(
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
                                      '6391 Elgin St. Celina, Island Delaware 10299',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Montserrat',
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    Text(
                                      '21.5km away',
                                      style: TextStyle(
                                        fontSize: 8.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Montserrat',
                                        color: Color(0xFF000000),
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
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(AppColors.white),
                                  side: WidgetStateProperty.all(
                                    const BorderSide(
                                        color: AppColors.grey4, width: 1),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RoutesName.livetracking);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(AppImages.watch),
                                    const SizedBox(width: 8.0),
                                    const Text(
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
                                    const SizedBox(width: 8.0),
                                    const Text(
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
                                const SizedBox(height: 15.0),
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
