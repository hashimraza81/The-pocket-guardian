import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/provider/location_Provider.dart';
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
  final String? phonenumber;

  const TrackingLocation(
      {super.key, this.lat, this.lng, this.imageUrl, this.phonenumber});

  @override
  _TrackingLocationState createState() => _TrackingLocationState();
}

class _TrackingLocationState extends State<TrackingLocation> {
  late CameraPosition _initialCameraPosition;
  bool _showOverlayImage = false;
  String _address = "Loading...";
  double? _distance;
  Position? position;
  bool isLatLngAvailable = false;

  Future<void> _fetchAddress() async {
    LocationService locationService = LocationService();

    try {
      position = await locationService.getCurrentLocation();
      String address =
          await locationService.getAddressFromLatLng(widget.lat!, widget.lng!);
      double distance = locationService.calculateDistance(
          position!.latitude, position!.longitude, widget.lat!, widget.lng!);

      setState(() {
        _address = address;
        _distance = distance;
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
    _initialCameraPosition = CameraPosition(
      target: LatLng(position?.latitude ?? 0, position?.longitude ?? 0),
      zoom: 14.4746,
    );
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

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    bool hasLatLng = widget.lat != null && widget.lng != null;
    if (isLatLngAvailable && widget.lat != null && widget.lng != null) {
      _initialCameraPosition = CameraPosition(
        target: LatLng(widget.lat!, widget.lng!),
        zoom: 14.4746,
      );
    }
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
                                radius: 30.0,
                                backgroundImage: widget.imageUrl != null
                                    ? NetworkImage(widget.imageUrl!)
                                    : null,
                                child: widget.imageUrl == null
                                    ? const Icon(Icons.person, size: 30.0)
                                    : null,
                              ),
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
                                // onPressed: () {
                                //   Navigator.pushNamed(
                                //       context, RoutesName.livetracking);
                                // },
                                onPressed: () {
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => LiveTracking(
                                  //       currentPersonLat: position!.latitude,
                                  //       currentPersonLng: position!.longitude,
                                  //       userLat: widget.lat!,
                                  //       userLng: widget.lng!,
                                  //     ),
                                  //   ),
                                  // );

                                  _launchGoogleMaps(
                                    widget.lat!,
                                    widget.lng!,
                                  );

                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => const LiveTracking(
                                  //       currentPersonLat:
                                  //           40.758896, // Times Square, NY
                                  //       currentPersonLng:
                                  //           -73.985130, // Times Square, NY
                                  //       userLat: 40.785091, // Central Park, NY
                                  //       userLng: -73.968285, // Central Park, NY
                                  //     ),
                                  //   ),
                                  // );
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
                                  onPressed: () async {
                                    await launchUrl(
                                      Uri(
                                        scheme: 'sms',
                                        path: widget.phonenumber,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                  colorbg: AppColors.secondary.withOpacity(0.2),
                                  bordercolor: AppColors.secondary,
                                  colortext: AppColors.primary,
                                ),
                                const SizedBox(height: 15.0),
                                ReusedButton(
                                  text: 'Call',
                                  onPressed: () async {
                                    await launchUrl(
                                      Uri(
                                        scheme: 'tel',
                                        path: widget.phonenumber,
                                      ),
                                    );
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
