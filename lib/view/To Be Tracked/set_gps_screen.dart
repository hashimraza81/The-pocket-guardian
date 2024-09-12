import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/places_provider.dart';
import 'package:gentech/utils/contact_listview.dart';
import 'package:intl/intl.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/provider.dart';

class SetGpsScreen extends StatefulWidget {
  const SetGpsScreen({super.key});

  @override
  State<SetGpsScreen> createState() => _SetGpsScreenState();
}

class _SetGpsScreenState extends State<SetGpsScreen> {
  static const CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(33.516842, 73.086052),
    zoom: 14.4746,
  );

  String locationMessage = "Please enable location services.";

  Future<void> checkLocationPermissions() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          setState(() {
            locationMessage = 'Location services are disabled.';
          });
          return;
        }
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            locationMessage = 'Location permissions are denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationMessage =
              'Location permissions are permanently denied, we cannot request permissions.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        locationMessage =
            'Current Position: ${position.latitude}, ${position.longitude}';
      });
    } catch (e) {
      setState(() {
        locationMessage = "Error: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserProfile(context);
    checkLocationPermissions();
    Provider.of<LocationPlacesProvider>(context, listen: false)
        .getUserCurrentLocation();
  }

  Future<void> fetchUserProfile(BuildContext context) async {
    await Provider.of<ProfileProvider>(context, listen: false).fetchUserData();
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
    final profileProvider = Provider.of<ProfileProvider>(context);
    String formattedDate =
        DateFormat('EEE d, MMM • hh:mm a').format(DateTime.now());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'GPS location',
            style: TextStyle(
              fontSize: 24.0.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
              color: AppColors.primary,
            ),
          ),
        ),
        body: Stack(
          children: [
            // Map Placeholder
            Positioned.fill(
              child: GoogleMap(
                initialCameraPosition: kGooglePlex,
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
            // User Information and Buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20.0.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0.r,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        profileProvider.isFetchingImage
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: CircleAvatar(
                                  radius: 30.r,
                                  backgroundColor: Colors.grey[300],
                                ),
                              )
                            : CircleAvatar(
                                radius: 30.r,
                                backgroundImage: profileProvider.pickedImage !=
                                        null
                                    ? FileImage(profileProvider.pickedImage!)
                                    : profileProvider.imageUrl.isNotEmpty
                                        ? NetworkImage(profileProvider.imageUrl)
                                        : null, // No image if URL is empty
                                backgroundColor: Colors.transparent,
                                child: profileProvider.imageUrl.isEmpty &&
                                        profileProvider.pickedImage == null
                                    ? CircleAvatar(
                                        radius: 30.r,
                                        child: Icon(
                                          Icons.person,
                                          size: 30.w,
                                          color: Colors.grey,
                                        ),
                                      )
                                    : null,
                              ),
                        // CircleAvatar(
                        //   radius: 30.r,
                        //   backgroundImage:
                        //       userProfileProvider.profileImageUrl.isNotEmpty
                        //           ? NetworkImage(
                        //               userProfileProvider.profileImageUrl)
                        //           : null, // No image when URL is empty
                        //   backgroundColor: Colors.transparent,
                        //   child: userProfileProvider.profileImageUrl.isEmpty
                        //       ? CircleAvatar(
                        //           radius: 30.r,
                        //           child: Icon(
                        //             Icons
                        //                 .person, // Display person icon when no image
                        //             size: 30.r, // Adjust icon size as needed
                        //             color: Colors
                        //                 .grey, // Adjust icon color as needed
                        //           ),
                        //         )
                        //       : null, // No child when there is an image
                        // ),
                        10.0.pw,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 12.0.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Montserrat',
                                  color: AppColors.grey3,
                                ),
                              ),
                              Text(
                                locationProvider.currentAddress ??
                                    'Set GPS location',
                                style: TextStyle(
                                  fontSize: 16.0.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // InkWell(
                        //   onTap: () async {
                        //     await locationProvider.getUserCurrentLocation();
                        //   },
                        //   child: SvgPicture.asset(
                        //     AppImages.refresh,
                        //     color: AppColors.secondary,
                        //     height: 30.h,
                        //     width: 30.w,
                        //   ),
                        // ),
                      ],
                    ),
                    10.0.ph,
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
                          onPressed: () async {
                            _showLoadingIndicator(context);
                            await locationProvider.getUserCurrentLocation();
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(AppImages.gpslogo),
                              8.0.pw,
                              const Text(
                                'Set GPS Location',
                                style: TextStyle(
                                  fontSize: 10,
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
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const CustomDialog();
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(AppImages.share),
                              8.0.pw,
                              const Text(
                                'Share',
                                style: TextStyle(
                                  fontSize: 10,
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
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 16.0.h,
          horizontal: 1.0.w,
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
              0.ph,
              const ContactListview(),
            ],
          ),
        ),
      ),
    );
  }
}
