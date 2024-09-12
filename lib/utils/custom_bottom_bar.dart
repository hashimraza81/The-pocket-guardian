// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:gentech/const/app_colors.dart';
// import 'package:gentech/const/app_images.dart';
// import 'package:gentech/provider/navigationProvider.dart';
// import 'package:gentech/routes/routes_names.dart';
// import 'package:gentech/utils/custom_text_widget.dart';
// import 'package:provider/provider.dart';

// class CustomBottomBar extends StatefulWidget {
//   const CustomBottomBar({super.key});

//   @override
//   State<CustomBottomBar> createState() => _CustomBottomBarState();
// }

// class _CustomBottomBarState extends State<CustomBottomBar> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.white,
//       width: double.infinity,
//       // height: 110.0.h,

//       child: Stack(
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 35.0.h),
//             child: Container(
//               height: 75.0.h,
//               width: double.infinity,
//               color: AppColors.white,
//               child: Consumer<NavigationProvider>(
//                   builder: (context, navigationProvider, child) {
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         navigationProvider.changeIndex(0, context);
//                       },
//                       child: SvgPicture.asset(AppImages.bottomhome),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         navigationProvider.changeIndex(1, context);
//                       },
//                       child: SvgPicture.asset(AppImages.bell),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ),
//           Positioned(
//             top: 10.0.h,
//             left: 130.0.w,
//             child: InkWell(
//               onTap: () {
//                 Navigator.pushNamed(context, RoutesName.alert);
//               },
//               child: CircleAvatar(
//                 radius: 45.0.r,
//                 backgroundColor: AppColors.secondary,
//                 child: CustomText(
//                   text: 'Alert',
//                   size: 22.0.sp,
//                   color: AppColors.white,
//                   familyFont: 'Montserrat',
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/provider/navigationProvider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:provider/provider.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
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
      color: AppColors.white,
      width: double.infinity,
      height: 60.h, // Fixed height for bottom bar
      child: Stack(
        clipBehavior: Clip
            .none, // Allow the Alert button to overflow outside the bottom bar
        alignment: Alignment.center, // Center alignment for the Stack
        children: [
          // Bottom bar background with home and notification icons
          Container(
            height: 60.0.h,
            color: AppColors.white,
            child: Consumer<NavigationProvider>(
              builder: (context, navigationProvider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigationProvider.changeIndex(0, context);
                      },
                      child: SvgPicture.asset(AppImages.bottomhome),
                    ),
                    GestureDetector(
                      onTap: () {
                        navigationProvider.changeIndex(1, context);
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
                            position:
                                badges.BadgePosition.topEnd(top: -8, end: -8),
                            child: SvgPicture.asset(
                              AppImages.bell,
                            ),
                          );
                        },
                      ),
                    )
                    // GestureDetector(
                    //   onTap: () {
                    //     navigationProvider.changeIndex(1, context);
                    //   },
                    //   child: SvgPicture.asset(AppImages.bell),
                    // ),
                  ],
                );
              },
            ),
          ),
          // Alert button positioned slightly above the bottom bar
          Positioned(
            top: -15.0.h,
            left: 145.w, // Slightly above the bottom bar
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.alert);
              },
              child: CircleAvatar(
                // radius: 45.0.r,
                radius: 35.r,
                backgroundColor: AppColors.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    text: 'Alert',
                    size: 12.0.sp,
                    color: AppColors.white,
                    familyFont: 'Montserrat',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
