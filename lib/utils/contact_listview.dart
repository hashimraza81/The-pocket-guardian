import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gentech/app%20notification/push_notification.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/firebase%20functions/firebase_services.dart';
import 'package:gentech/model/contact_model.dart';
import 'package:gentech/provider/location_Provider.dart';
import 'package:gentech/provider/option_provider.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListview extends StatefulWidget {
  const ContactListview({super.key});

  @override
  State<ContactListview> createState() => _ContactListviewState();
}

class _ContactListviewState extends State<ContactListview> {
  final FirebaseFunctions _firebaseFunctions = FirebaseFunctions();
  List<Contact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userRole =
          Provider.of<UserChoiceProvider>(context, listen: false).userChoice;
      String collectionToSearch =
          userRole == 'Track' ? 'trackUsers' : 'trackingUsers';

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collectionToSearch)
          .doc(user.uid)
          .collection('contacts')
          .get();

      List<Contact> contacts = snapshot.docs.map((doc) {
        return Contact.fromFirestore(doc);
      }).toList();

      setState(() {
        _contacts = contacts;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.sccafold,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    return Container(
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
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class IconButtonWithMenu extends StatelessWidget {
  final GlobalKey _key = GlobalKey();
  final String phoneNumber;
  final String email;

  IconButtonWithMenu(
      {super.key, required this.phoneNumber, required this.email});

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
                  Provider.of<LocationProvider>(context, listen: false);
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
        PopupMenuItem(
          child: _buildOption(
            context,
            "App notifications",
            Provider.of<OptionProvider>(context, listen: false)
                        .selectedOption ==
                    "App notifications"
                ? AppColors.secondary
                : AppColors.secondary.withOpacity(0.1),
            Provider.of<OptionProvider>(context, listen: false)
                        .selectedOption ==
                    "App notifications"
                ? Colors.white
                : AppColors.primary,
            () {
              Provider.of<OptionProvider>(context, listen: false)
                  .setSelectedOption("App notifications");
              print('hashum');

              PushNotification.sendNotificationToSelectedRole(
                  "e6m3sesTRgiHp8gb1DKJFH:APA91bHxEFfS9vvU2U7Tt4nNtckCsNZI3OEbrz6Qn-squWTESeltGnTMNwf56p1bXofPdY7053M9rDPPQZ1Iuf6EFBn3L0wXcwdb2bGoMaGPwXW2DxxZwLGmss9yrTpFWcQd3_SK7dsq",
                  context,
                  '123');
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
