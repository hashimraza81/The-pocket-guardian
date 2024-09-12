// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gentech/const/app_colors.dart';
// import 'package:gentech/const/app_images.dart';
// import 'package:gentech/extension/sizebox_extension.dart';
// import 'package:gentech/model/contact_model.dart';
// import 'package:gentech/provider/places_provider.dart';
// import 'package:gentech/utils/contact_listview.dart';
// import 'package:gentech/utils/custom_text_widget.dart';
// import 'package:gentech/utils/reused_button.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../Location Service Functions/location_services.dart';
// import '../../provider/provider.dart';

// class TrackingLocation extends StatefulWidget {
//   final double? lat;
//   final double? lng;
//   final String? imageUrl;
//   final bool? fromNotificationRoute;
//   final String? phonenumber;

//   const TrackingLocation({
//     super.key,
//     this.lat,
//     this.lng,
//     this.imageUrl,
//     this.fromNotificationRoute,
//     this.phonenumber,
//   });

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
//       String address = widget.fromNotificationRoute == true
//           ? await locationService.getAddressFromLatLng(widget.lat!, widget.lng!)
//           : await locationService.getAddressFromLatLng(
//               position!.latitude, position!.longitude);
//       if (widget.fromNotificationRoute == true) {
//         double distance = locationService.calculateDistance(
//             position!.latitude, position!.longitude, widget.lat!, widget.lng!);
//         setState(() {
//           _distance = distance;
//         });
//       }
//       setState(() {
//         _address = address;
//         _initialCameraPosition = widget.fromNotificationRoute == true
//             ? CameraPosition(
//                 target: LatLng(widget.lat!, widget.lng!),
//                 zoom: 14.4746,
//               )
//             : CameraPosition(
//                 target: LatLng(position!.latitude, position!.longitude),
//                 zoom: 14.4746,
//               );
//         _markers = {
//           Marker(
//             markerId: const MarkerId('currentLocation'),
//             position: widget.fromNotificationRoute == true
//                 ? LatLng(widget.lat!, widget.lng!)
//                 : LatLng(position!.latitude, position!.longitude),
//             infoWindow: InfoWindow(
//               title: widget.fromNotificationRoute == true
//                   ? 'Notification Location'
//                   : 'Current Location',
//             ),
//           ),
//         };
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
//     Provider.of<ProfileProvider>(context, listen: false).fetchUserData();
//   }

//   Future<void> _launchGoogleMaps(double destLat, double destLng) async {
//     if (position != null) {
//       final String googleMapsUrl =
//           'https://www.google.com/maps/dir/?api=1&origin=${position!.latitude},${position!.longitude}&destination=$destLat,$destLng';

//       if (await canLaunch(googleMapsUrl)) {
//         await launch(googleMapsUrl);
//       } else {
//         throw 'Could not open Google Maps';
//       }
//     } else {
//       print('Current position is not available');
//     }
//   }

//   void _showContactDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return CustomDialog(
//           onContactSelected: (contact) {
//             // Handle contact selection here
//             Navigator.pop(context);
//             _showContactOptionsDialog(contact);
//           },
//         );
//       },
//     );
//   }

//   void _showContactOptionsDialog(Contact contact) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Contact Options for ${contact.name}'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.call),
//                 title: const Text('Call'),
//                 onTap: () {
//                   // Directly launch a call to the contact's phone number
//                   _launchPhoneCall(contact.phoneNumber);
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.message),
//                 title: const Text('Message'),
//                 onTap: () {
//                   // Directly launch a message to the contact's phone number
//                   _launchSMS(contact.phoneNumber);
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _launchPhoneCall(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'tel',
//       path: phoneNumber,
//     );
//     if (await canLaunchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     } else {
//       print('Could not launch $launchUri');
//     }
//   }

//   void _launchSMS(String phoneNumber) async {
//     final Uri launchUri = Uri(
//       scheme: 'sms',
//       path: phoneNumber,
//     );
//     if (await canLaunchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     } else {
//       print('Could not launch $launchUri');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final locationProvider = Provider.of<LocationPlacesProvider>(context);
//     final profileProvider = Provider.of<ProfileProvider>(context);
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
//                   ? const Center(child: CircularProgressIndicator())
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
//                   // Icon(
//                   //   Icons.location_on,
//                   //   size: 50,
//                   //   color: AppColors.secondary,
//                   // ),
//                 ],
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
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(20.0),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 10.0,
//                           offset: Offset(0, -2),
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
//                               backgroundImage:
//                                   profileProvider.imageUrl.isNotEmpty
//                                       ? NetworkImage(profileProvider.imageUrl)
//                                       : null,
//                               child: profileProvider.imageUrl.isEmpty
//                                   ? const Icon(Icons.person, size: 30.0)
//                                   : null,
//                             ),
//                             const SizedBox(width: 10.0),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
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
//                                     style: const TextStyle(
//                                       fontSize: 16.0,
//                                       fontWeight: FontWeight.w600,
//                                       fontFamily: 'Montserrat',
//                                       color: AppColors.primary,
//                                     ),
//                                   ),
//                                   if (_distance != null)
//                                     Text(
//                                       "Distance: ${_distance!.toStringAsFixed(2)} km",
//                                       style: const TextStyle(
//                                         fontSize: 8.0,
//                                         fontWeight: FontWeight.w400,
//                                         fontFamily: 'Montserrat',
//                                         color: Color(0xFF000000),
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
//                         const SizedBox(height: 10.0),
//                         if (widget.fromNotificationRoute == true)
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               ElevatedButton(
//                                 style: ButtonStyle(
//                                   backgroundColor:
//                                       WidgetStateProperty.all(AppColors.white),
//                                   side: WidgetStateProperty.all(
//                                     const BorderSide(
//                                         color: AppColors.grey4, width: 1),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   // Navigator.push(
//                                   //   context,
//                                   //   MaterialPageRoute(
//                                   //     builder: (context) => LiveTracking(
//                                   //       currentPersonLat: position!.latitude,
//                                   //       currentPersonLng: position!.longitude,
//                                   //       userLat: widget.lat!,
//                                   //       userLng: widget.lng!,
//                                   //     ),
//                                   //   ),
//                                   // );

//                                   _launchGoogleMaps(
//                                     widget.lat!,
//                                     widget.lng!,
//                                   );
//                                 },
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     SvgPicture.asset(AppImages.watch),
//                                     const SizedBox(width: 8.0),
//                                     const Text(
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
//                                     const SizedBox(width: 8.0),
//                                     const Text(
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
//                                   _showContactDialog();
//                                 },
//                                 colorbg: AppColors.secondary.withOpacity(0.2),
//                                 bordercolor: AppColors.secondary,
//                                 colortext: AppColors.primary,
//                               ),
//                               const SizedBox(height: 15.0),
//                               ReusedButton(
//                                 text: 'Call',
//                                 onPressed: () {
//                                   _showContactDialog();
//                                 },
//                                 // onPressed: () async {
//                                 //   await launchUrl(
//                                 //     Uri(
//                                 //       scheme: 'tel',
//                                 //       path: widget.phonenumber,
//                                 //     ),
//                                 //   );
//                                 //   Navigator.pop(context);
//                                 // },
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

// class CustomDialog extends StatelessWidget {
//   final void Function(Contact contact) onContactSelected;

//   const CustomDialog({super.key, required this.onContactSelected});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0.r),
//       ),
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           vertical: 16.0.h,
//           horizontal: 10.0.w,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 'Contacts',
//                 style: TextStyle(
//                   fontSize: 18.0.sp,
//                   fontWeight: FontWeight.w700,
//                   fontFamily: 'Montserrat',
//                   color: AppColors.primary,
//                 ),
//               ),
//             ),
//             16.0.ph,
//             ContactListview(onContactSelected: onContactSelected),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/model/contact_model.dart';
import 'package:gentech/provider/places_provider.dart';
import 'package:gentech/provider/provider.dart';
import 'package:gentech/utils/contact_listview.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Location Service Functions/location_services.dart';

class TrackingLocation extends StatefulWidget {
  final double? lat;
  final double? lng;
  final String? imageUrl;
  final bool? fromNotificationRoute;
  final String? phonenumber;

  const TrackingLocation({
    super.key,
    this.lat,
    this.lng,
    this.imageUrl,
    this.fromNotificationRoute,
    this.phonenumber,
  });

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
          : await locationService.getAddressFromLatLng(
              position!.latitude, position!.longitude);

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
            markerId: const MarkerId('currentLocation'),
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

  // Future<void> _fetchAddress() async {
  //   LocationService locationService = LocationService();

  //   try {
  //     position = await locationService.getCurrentLocation();
  //     String address = widget.fromNotificationRoute == true
  //         ? await locationService.getAddressFromLatLng(widget.lat!, widget.lng!)
  //         : await locationService.getAddressFromLatLng(
  //             position!.latitude, position!.longitude);
  //     if (widget.fromNotificationRoute == true) {
  //       double distance = locationService.calculateDistance(
  //           position!.latitude, position!.longitude, widget.lat!, widget.lng!);
  //       setState(() {
  //         _distance = distance;
  //       });
  //     }
  //     setState(() {
  //       _address = address;
  //       _initialCameraPosition = widget.fromNotificationRoute == true
  //           ? CameraPosition(
  //               target: LatLng(widget.lat!, widget.lng!),
  //               zoom: 14.4746,
  //             )
  //           : CameraPosition(
  //               target: LatLng(position!.latitude, position!.longitude),
  //               zoom: 14.4746,
  //             );
  //       _markers = {
  //         Marker(
  //           markerId: const MarkerId('currentLocation'),
  //           position: widget.fromNotificationRoute == true
  //               ? LatLng(widget.lat!, widget.lng!)
  //               : LatLng(position!.latitude, position!.longitude),
  //           infoWindow: InfoWindow(
  //             title: widget.fromNotificationRoute == true
  //                 ? 'Notification Location'
  //                 : 'Current Location',
  //           ),
  //         ),
  //       };
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _address = "Error fetching address: $e";
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _launchGoogleMaps(double destLat, double destLng) async {
    if (position != null) {
      final String googleMapsUrl =
          'https://www.google.com/maps/dir/?api=1&origin=${position!.latitude},${position!.longitude}&destination=$destLat,$destLng';

      if (await canLaunch(googleMapsUrl)) {
        await launch(googleMapsUrl);
      } else {
        throw 'Could not open Google Maps';
      }
    } else {
      print('Current position is not available');
    }
  }

  void _showMessageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          onContactSelected: (contact) {
            // Handle contact selection here
            Navigator.pop(context);
            _showMessageOptionsDialog(contact);
          },
        );
      },
    );
  }

  void _showMessageOptionsDialog(Contact contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Contact Options for ${contact.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Message'),
                onTap: () {
                  // Directly launch a message to the contact's phone number
                  _launchSMS(contact.phoneNumber);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCallDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          onContactSelected: (contact) {
            // Handle contact selection here
            Navigator.pop(context);
            _showCallOptionsDialog(contact);
          },
        );
      },
    );
  }

  void _showCallOptionsDialog(Contact contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Contact Options for ${contact.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.call),
                title: const Text('Call'),
                onTap: () {
                  // Directly launch a call to the contact's phone number
                  _launchPhoneCall(contact.phoneNumber);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _launchPhoneCall(String phoneNumber) async {
    await launchUrl(
      Uri(
        scheme: 'tel',
        path: phoneNumber,
      ),
    );
  }

  void _launchSMS(String phoneNumber) async {
    await launchUrl(
      Uri(
        scheme: 'sms',
        path: phoneNumber,
      ),
    );
  }

  void _showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationPlacesProvider>(context);
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
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.primary,
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
                  ? const Center(child: CircularProgressIndicator())
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
                children: [],
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
                              radius: 30.0,
                              backgroundImage: widget.fromNotificationRoute ==
                                      true
                                  ? (widget.imageUrl != null
                                      ? NetworkImage(widget
                                          .imageUrl!) // Notification image
                                      : null)
                                  : (Provider.of<ProfileProvider>(context)
                                              .imageUrl !=
                                          null
                                      ? NetworkImage(Provider.of<
                                              ProfileProvider>(context)
                                          .imageUrl) // Logged-in user's image
                                      : null),
                              child: widget.fromNotificationRoute == true &&
                                      widget.imageUrl == null
                                  ? const Icon(Icons.person,
                                      size:
                                          30.0) // Placeholder icon if no image is available from notification
                                  : (Provider.of<ProfileProvider>(context)
                                              .imageUrl ==
                                          null
                                      ? const Icon(Icons.person,
                                          size:
                                              30.0) // Placeholder icon if no logged-in user's image is available
                                      : null),
                            ),

                            // CircleAvatar(
                            //   radius: 30.0,
                            //   backgroundImage: widget.imageUrl != null
                            //       ? NetworkImage(widget.imageUrl!)
                            //       : null,
                            //   child: widget.imageUrl == null
                            //       ? const Icon(Icons.person, size: 30.0)
                            //       : null,
                            // ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
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
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Montserrat',
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  if (_distance != null)
                                    Text(
                                      "Distance: ${_distance!.toStringAsFixed(2)} km",
                                      style: const TextStyle(
                                        fontSize: 8.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Montserrat',
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // InkWell(
                            //   onTap: () {
                            //     _showLoadingIndicator(context);
                            //     _fetchAddress();
                            //     Navigator.pop(context);
                            //   },
                            //   child: SvgPicture.asset(
                            //     AppImages.refresh,
                            //     color: AppColors.secondary,
                            //     height: 30,
                            //     width: 30,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        if (widget.fromNotificationRoute == true)
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
                                  _launchGoogleMaps(
                                    widget.lat!,
                                    widget.lng!,
                                  );
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
                                  _showMessageDialog();
                                },
                                colorbg: AppColors.secondary.withOpacity(0.2),
                                bordercolor: AppColors.secondary,
                                colortext: AppColors.primary,
                              ),
                              const SizedBox(height: 15.0),
                              ReusedButton(
                                text: 'Call',
                                onPressed: () {
                                  _showCallDialog();
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

class CustomDialog extends StatelessWidget {
  final void Function(Contact contact) onContactSelected;

  const CustomDialog({super.key, required this.onContactSelected});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        // height: 400,
        padding: EdgeInsets.symmetric(
          vertical: 16.0.h,
          horizontal: 1,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                // alignment: Alignment.topLeft,
                child: Text(
                  'Contacts',
                  style: TextStyle(
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Montserrat',
                    color: AppColors.primary,
                  ),
                ),
              ),
              16.0.ph,
              ContactListview(onContactSelected: onContactSelected),
            ],
          ),
        ),
      ),
    );
  }
}
