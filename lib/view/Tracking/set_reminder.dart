import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/tracking_bottom_bar_Provider.dart';
import 'package:gentech/utils/custom_bottom_bar.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/snackbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

class SetReminder extends StatefulWidget {
  final List<String>? selectedContacts;
  const SetReminder({super.key, this.selectedContacts});

  @override
  State<SetReminder> createState() => _SetReminderState();
}

class _SetReminderState extends State<SetReminder> {
  var hour = 12;
  var minute = 0;
  var timeFormat = "AM";

  @override
  Widget build(BuildContext context) {
    final List<String> selectedContactUids = widget.selectedContacts!;
    return ChangeNotifierProvider(
      create: (context) => TrackingBottomBarProvider(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.sccafold,
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
              text: 'Set Reminder',
              size: 24.0.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              familyFont: 'Montserrat',
            ),
            centerTitle: true,
          ),
          backgroundColor: AppColors.sccafold,
          resizeToAvoidBottomInset: true,
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 25.0.h,
                horizontal: 15.0.w,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.0.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0.h,
                          horizontal: 15.0.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Set Reminder',
                              size: 20.0.sp,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w700,
                              familyFont: 'Montserrat',
                            ),
                            20.0.ph,
                            SizedBox(
                              height: 50.0,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  CustomButton(
                                    text: 'No Reminder',
                                    onPressed: _cancelReminder,
                                    colorbg: AppColors.white,
                                    colortext: AppColors.primary,
                                    bordercolor: AppColors.grey4,
                                    size: 12.0.sp,
                                    radius: 12.0.r,
                                  ),
                                  CustomButton(
                                    text: 'In An Hour',
                                    onPressed: () {
                                      _setReminder(
                                        const Duration(hours: 1),
                                        selectedContactUids,
                                      );
                                    },
                                    colorbg: AppColors.grey6,
                                    colortext: AppColors.primary,
                                    size: 12.0.sp,
                                    radius: 12.0.r,
                                  ),
                                  CustomButton(
                                    text: 'In Two Hours',
                                    onPressed: () {
                                      _setReminder(
                                        const Duration(hours: 2),
                                        selectedContactUids,
                                      );
                                    },
                                    colorbg: AppColors.grey6,
                                    colortext: AppColors.primary,
                                    size: 12.0.sp,
                                    radius: 12.0.r,
                                  ),
                                ],
                              ),
                            ),
                            20.0.ph,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.grey6,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 50.0.w,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              timeFormat = "AM";
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                              color: timeFormat == "AM"
                                                  ? AppColors.primary
                                                  : AppColors.white,
                                              border: Border.all(
                                                color: timeFormat == "AM"
                                                    ? AppColors.white
                                                    : AppColors.primary,
                                              ),
                                            ),
                                            child: Text(
                                              "AM",
                                              style: TextStyle(
                                                  color: timeFormat == "AM"
                                                      ? AppColors.white
                                                      : AppColors.primary,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              timeFormat = "PM";
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w,
                                                vertical: 10.h),
                                            decoration: BoxDecoration(
                                              color: timeFormat == "PM"
                                                  ? AppColors.primary
                                                  : AppColors.white,
                                              border: Border.all(
                                                color: timeFormat == "AM"
                                                    ? AppColors.primary
                                                    : AppColors.white,
                                              ),
                                            ),
                                            child: Text(
                                              "PM",
                                              style: TextStyle(
                                                color: timeFormat == "PM"
                                                    ? AppColors.white
                                                    : AppColors.primary,
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    10.0.ph,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        NumberPicker(
                                          minValue: 1,
                                          maxValue: 12,
                                          value: hour,
                                          zeroPad: true,
                                          infiniteLoop: true,
                                          itemWidth: 80,
                                          itemHeight: 60,
                                          onChanged: (value) {
                                            setState(() {
                                              hour = value;
                                            });
                                          },
                                          textStyle: const TextStyle(
                                              color: AppColors.grey4,
                                              fontSize: 20),
                                          selectedTextStyle: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 30),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                  color: Colors.white,
                                                ),
                                                bottom: BorderSide(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        NumberPicker(
                                          minValue: 0,
                                          maxValue: 59,
                                          value: minute,
                                          zeroPad: true,
                                          infiniteLoop: true,
                                          itemWidth: 80,
                                          itemHeight: 60,
                                          onChanged: (value) {
                                            setState(() {
                                              minute = value;
                                            });
                                          },
                                          textStyle: const TextStyle(
                                              color: AppColors.grey4,
                                              fontSize: 20),
                                          selectedTextStyle: const TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 30),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                                top: BorderSide(
                                                  color: Colors.white,
                                                ),
                                                bottom: BorderSide(
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            20.0.ph,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomButton(
                                  text: 'Cancel',
                                  onPressed: _cancelReminder,
                                  colorbg: AppColors.white,
                                  colortext: AppColors.secondary,
                                  size: 16.0.sp,
                                  bordercolor: AppColors.secondary,
                                  radius: 128.0.r,
                                ),
                                CustomButton(
                                  text: 'Done',
                                  onPressed: () {
                                    _setCustomReminder(selectedContactUids);
                                    Navigator.pop(context);
                                  },
                                  colorbg: AppColors.secondary,
                                  colortext: AppColors.white,
                                  size: 16.0.sp,
                                  radius: 128.0.r,
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
            ),
          ),
          bottomNavigationBar: const CustomBottomBar(),
        ),
      ),
    );
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permission denied.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permission permanently denied.');
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String?> _fetchDeviceToken(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('trackingUsers')
          .doc(userId)
          .get();
      if (doc.exists) {
        return doc.data() != null
            ? (doc.data() as Map<String, dynamic>)['deviceToken'] as String?
            : null;
      }
      print('Document does not exist for user: $userId');
    } catch (e) {
      print('Error fetching device token for $userId: $e');
    }
    return null;
  }

  void _setReminder(Duration duration, List<String> selectedContactUids) {
    for (String uid in selectedContactUids) {
      _fetchDeviceToken(uid).then((deviceToken) async {
        if (deviceToken != null) {
          Position? position = await _getCurrentLocation();
          User? currentUser = FirebaseAuth.instance.currentUser;

          if (position != null && currentUser != null) {
            String senderId = currentUser.uid;
            String mapsUrl =
                'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

            Workmanager().registerOneOffTask(
              uid + DateTime.now().toString(),
              "reminderTask",
              initialDelay: duration,
              inputData: {
                'deviceToken': deviceToken,
                'uid': uid,
                'senderId': senderId,
                'mapsUrl': mapsUrl,
                'latitude': position.latitude,
                'longitude': position.longitude,
              },
            );
          }
        }
      });
    }

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Reminder set for ${duration.inHours} hours'),
    //   ),
    // );
    // showTopSnackBar(
    //   context,
    //   'Reminder set for ${duration.inHours} hours',
    //   Colors.green,
    // );
  }

  void _setCustomReminder(List<String> selectedContactUids) {
    final now = DateTime.now();
    int hour24 = hour % 12 + (timeFormat == "PM" ? 12 : 0);
    final selectedTime = DateTime(now.year, now.month, now.day, hour24, minute);
    var duration = selectedTime.difference(now);

    if (duration.isNegative) {
      duration += const Duration(days: 1);
    }

    _setReminder(duration, selectedContactUids);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //         'Reminder set for $hour:${minute.toString().padLeft(2, '0')} $timeFormat'),
    //   ),
    // );

    showTopSnackBar(
      context,
      'Reminder set for $hour:${minute.toString().padLeft(2, '0')} $timeFormat',
      Colors.green,
    );
  }

  void _cancelReminder() {
    Workmanager().cancelAll();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Reminder cancelled'),
    //   ),
    // );
    showTopSnackBar(
      context,
      'Reminder cancelled',
      Colors.green,
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  Color? colorbg;
  Color? colortext;
  Color? bordercolor;
  final double? size;
  final double? radius;

  CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.colorbg,
    this.colortext,
    this.bordercolor,
    this.size,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorbg,
          borderRadius: BorderRadius.circular(radius!),
          border: Border.all(
            width: 1,
            color: bordercolor ?? Colors.transparent,
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: size,
              color: colortext,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
    );
  }
}
