import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/provider/tracking_bottom_bar_Provider.dart';
import 'package:provider/provider.dart';

class TrackingBottomBar extends StatefulWidget {
  const TrackingBottomBar({super.key});

  @override
  State<TrackingBottomBar> createState() => _TrackingBottomBarState();
}

class _TrackingBottomBarState extends State<TrackingBottomBar> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch notifications for logged-in user
  Stream<int> getNotificationCount() {
    User? currentUser =
        _auth.currentUser; // Logged-in user ki UID ko access karein

    if (currentUser == null) {
      // Agar user null ho to 0 return karein
      return Stream.value(0);
    }
    print('Current User UID: ${currentUser.uid}');

    return _firestore
        .collection('pushNotifications')
        .where('receiverId', isEqualTo: currentUser.uid) // Filter based on UID
        .snapshots()
        .map((snapshot) {
      print('hashim ${snapshot.docs.length}');
      return snapshot.docs.length;
      // Return the count of notifications
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0.h,
      width: double.infinity,
      color: AppColors.white,
      child: Consumer<TrackingBottomBarProvider>(
          builder: (context, TrackingBottomBarProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                TrackingBottomBarProvider.changeIndex(0, context);
              },
              child: SvgPicture.asset(
                AppImages.bottomhome,
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     TrackingBottomBarProvider.changeIndex(1, context);
            //   },
            //   child: SvgPicture.asset(
            //     AppImages.bell,

            //   ),
            // ),
            GestureDetector(
              onTap: () {
                TrackingBottomBarProvider.changeIndex(1, context);
              },
              child: StreamBuilder<int>(
                stream: getNotificationCount(),
                builder: (context, snapshot) {
                  int notificationCount = snapshot.data ?? 0;
                  return badges.Badge(
                    badgeContent: Text(
                      notificationCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: Colors.red,
                    ),
                    position: badges.BadgePosition.topEnd(top: -8, end: -8),
                    child: SvgPicture.asset(
                      AppImages.bell,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
