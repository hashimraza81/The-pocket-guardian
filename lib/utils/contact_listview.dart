import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gentech/app%20notification/push_notification.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/firebase%20functions/get_device_token.dart';
import 'package:gentech/model/contact_model.dart';
import 'package:gentech/provider/contact_provider.dart';
import 'package:gentech/provider/option_provider.dart';
import 'package:gentech/provider/places_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

import '../routes/routes_names.dart';

class ContactListview extends StatelessWidget {
  final void Function(Contact contact)? onContactSelected;
  const ContactListview({super.key, this.onContactSelected});



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactProvider()..subscribeToContacts(context),
      child: Consumer<ContactProvider>(
        builder: (context, contactProvider, _) {
          if (contactProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // If the contacts are empty after loading, fetch from Firestore
          if (contactProvider.contacts.isEmpty) {
            // contactProvider.subscribeToContacts(context);
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: contactProvider.contacts.length,
            itemBuilder: (context, index) {
              final contact = contactProvider.contacts[index];
              return InkWell(
                onTap: onContactSelected != null
                    ? () => onContactSelected!(contact)
                    : null,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: contact.imageUrl.isNotEmpty
                                ? NetworkImage(contact.imageUrl)
                                : const AssetImage(AppImages.profile)
                                    as ImageProvider,
                            radius: 20.0,
                            // child: contact.imageUrl.isNotEmpty
                            //     ? Image.network(contact.imageUrl)
                            //     : const Icon(
                            //         Icons.person,
                            //         size: 35.0,
                            //       ),
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact.name,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Montserrat',
                                  color: AppColors.primary,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.phone,
                                      size: 16.0, color: AppColors.primary),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    contact.phoneNumber,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Montserrat',
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButtonWithMenu(
                            phoneNumber: contact.phoneNumber,
                            email: contact.email,
                            contacts: contact,
                            receiverId: contact.uid,
                          ),
                        ],
                      ),
                    ),
                    10.ph,
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class IconButtonWithMenu extends StatelessWidget {
  final GlobalKey _key = GlobalKey();
  final String phoneNumber;
  final String email;
  final Contact contacts;
  final String receiverId;

  IconButtonWithMenu({
    super.key,
    required this.phoneNumber,
    required this.email,
    required this.contacts,
    required this.receiverId,
  });

  Future<void> _sendEmail(String body, String email) async {
    final encodedBody = Uri.encodeComponent(body).replaceAll('+', '%20');
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query:
          'subject=${Uri.encodeComponent('Emergency: Relative in Trouble')}&body=$encodedBody',
    );
    await launchUrl(emailUri);
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return early.
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, return early.
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, return early.
      return null;
    }

    // When we reach here, permissions are granted, and we can fetch the location.
    return await Geolocator.getCurrentPosition();
  }

  Future<Position?> _onLocationIconTapped() async {
    Position? position = await _getCurrentLocation();
    if (position != null) {
      print('Current position: ${position.latitude}, ${position.longitude}');
      print(position);
      return position;

      // You can handle the location data here, such as updating the UI or sending it to a server.
    } else {
      print('Failed to get current location.');
    }
    return null;
  }

  void _showDialog(BuildContext context) {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + 1,
        offset.dy + 1,
      ),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          child: _buildOption(
            context,
            "Email",
            Provider.of<OptionProvider>(context, listen: false)
                        .selectedOption ==
                    "Email"
                ? AppColors.secondary
                : AppColors.secondary.withOpacity(0.1),
            Provider.of<OptionProvider>(context, listen: false)
                        .selectedOption ==
                    "Email"
                ? Colors.white
                : AppColors.primary,
            () async {
              Provider.of<OptionProvider>(context, listen: false)
                  .setSelectedOption("Email");

              final locationProvider =
                  Provider.of<LocationPlacesProvider>(context, listen: false);
              await locationProvider.getUserCurrentLocation();

              String mapsUrl =
                  'https://www.google.com/maps/search/?api=1&query=${locationProvider.currentPosition!.latitude},${locationProvider.currentPosition!.longitude}';
              String body =
                  'Your relative is in trouble.\nCurrent Location: $mapsUrl';

              await _sendEmail(body, email);

              Navigator.pop(context);
            },
          ),
        ),
        PopupMenuItem(
          child: _buildOption(
            context,
            "Phone calls",
            Provider.of<OptionProvider>(context, listen: false)
                        .selectedOption ==
                    "Phone calls"
                ? AppColors.secondary
                : AppColors.secondary.withOpacity(0.1),
            Provider.of<OptionProvider>(context, listen: false)
                        .selectedOption ==
                    "Phone calls"
                ? Colors.white
                : AppColors.primary,
            () async {
              Provider.of<OptionProvider>(context, listen: false)
                  .setSelectedOption("Phone calls");

              await launchUrl(
                Uri(
                  scheme: 'tel',
                  path: phoneNumber,
                ),
              );
              Navigator.pop(context);
            },
          ),
        ),
        // PopupMenuItem(
        //   child: _buildOption(
        //     context,
        //     "App notifications",
        //     Provider.of<OptionProvider>(context, listen: false)
        //                 .selectedOption ==
        //             "App notifications"
        //         ? AppColors.secondary
        //         : AppColors.secondary.withOpacity(0.1),
        //     Provider.of<OptionProvider>(context, listen: false)
        //                 .selectedOption ==
        //             "App notifications"
        //         ? Colors.white
        //         : AppColors.primary,
        //     () async {
        //       Position? position = await _onLocationIconTapped();
        //       if (position != null) {
        //         Provider.of<OptionProvider>(context, listen: false)
        //             .setSelectedOption("App notifications");
        //
        //         // Fetch the device token from the contact
        //         String? deviceToken = await getDeviceTokenFromContact(contacts);
        //
        //         if (deviceToken != null) {
        //           User? currentUser = FirebaseAuth.instance.currentUser;
        //           if (currentUser != null) {
        //             String senderId = currentUser.uid;
        //             String mapsUrl =
        //                 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
        //             String body = mapsUrl;
        //             await PushNotification.sendNotificationToSelectedRole(
        //               deviceToken,
        //               context,
        //               senderId,
        //               receiverId,
        //               position.latitude,
        //               position.longitude,
        //               "Notification",
        //               body,
        //             );
        //           } else {
        //             print('Failed to retrieve current user ID.');
        //           }
        //         } else {
        //           print('Failed to retrieve device token.');
        //         }
        //       }
        //
        //       Navigator.pop(context);
        //     },
        //   ),
        //   // () async {
        //   //   var latalng = _onLocationIconTapped();
        //   //   Provider.of<OptionProvider>(context, listen: false)
        //   //       .setSelectedOption("App notifications");
        //
        //   //   // final locationProvider = Provider.of<LocationProvider>(context);
        //   //   // print("hashim ${locationProvider.currentAddress}");
        //
        //   //   // Fetch the device token from the contact
        //   //   String? deviceToken = await getDeviceTokenFromContact(contacts);
        //
        //   //   if (deviceToken != null) {
        //   //     // Use the device token to send a notification
        //   //     // PushNotification.sendNotificationToSelectedRole(
        //   //     //     deviceToken, context, 'Notification title or message');
        //
        //   //     // PushNotification.sendNotificationToSelectedRole(
        //   //     //   deviceToken,
        //   //     //   context,
        //   //     //   'senderId',
        //   //     //   'receiverId',
        //   //     //   'SenderName is requesting you acsess his/her location ',
        //   //     //   latalng,
        //   //     // );
        //
        //   //     PushNotification.sendNotificationToSelectedRole(deviceToken, context, 'senderId', 'receiverId', lat, lng, "title", 'body',)
        //   //   } else {
        //   //     print('Failed to retrieve device token.');
        //   //   }
        //
        //   //   Navigator.pop(context);
        //   // },
        // ),
        PopupMenuItem(
          child: _buildOption(
            context,
            "App notifications",
            Provider.of<OptionProvider>(context, listen: false).selectedOption == "App notifications"
                ? AppColors.secondary
                : AppColors.secondary.withOpacity(0.1),
            Provider.of<OptionProvider>(context, listen: false).selectedOption == "App notifications"
                ? Colors.white
                : AppColors.primary,
                () async {
              Position? position = await _onLocationIconTapped();
              if (position != null) {
                Provider.of<OptionProvider>(context, listen: false).setSelectedOption("App notifications");

                // Fetch the device token from the contact
                String? deviceToken = await getDeviceTokenFromContact(contacts);

                if (deviceToken != null) {
                  User? currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                     String senderId = currentUser.uid;
                    // String mapsUrl = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

                    // Check the user's role and set the notification body accordingly
                    DocumentSnapshot trackingUserDoc = await FirebaseFirestore.instance
                        .collection('trackingUsers')
                        .doc(senderId)
                        .get();

                    String body;

                    if (trackingUserDoc.exists) {
                      // Notification body for TrackingUser
                      String senderId = currentUser.uid;
                      await PushNotification.sendNotificationToUser(
                        deviceToken,
                        context,
                        senderId,
                        receiverId,
                        "Notification",
                        "I want to access your location"
                      );
                    } else {
                      // Check if the user is in the 'TrackedUser' collection
                      DocumentSnapshot trackedUserDoc = await FirebaseFirestore.instance
                          .collection('trackUsers')
                          .doc(senderId)
                          .get();

                      if (trackedUserDoc.exists) {
                        // Notification body for TrackedUser
                        String senderId = currentUser.uid;
                                    String mapsUrl =
                                        'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
                        String body = mapsUrl;
                        await PushNotification.sendNotificationToSelectedRole(
                          deviceToken,
                          context,
                          senderId,
                          receiverId,
                          position.latitude,
                          position.longitude,
                          "Notification",
                          body,
                        );
                      } else {
                        print('User role is unknown.');
                        return;
                      }
                    }
                  } else {
                    print('Failed to retrieve current user ID.');
                  }
                } else {
                  print('Failed to retrieve device token.');
                }
              }

              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }


  Widget _buildOption(BuildContext context, String title, Color bgColor,
      Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: bgColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final optionProvider = context.watch<OptionProvider>();

    return IconButton(
      key: _key,
      onPressed: () {
        _showDialog(context);
      },
      icon: const Icon(
        Icons.more_vert,
        color: AppColors.primary,
      ),
    );
  }
}
