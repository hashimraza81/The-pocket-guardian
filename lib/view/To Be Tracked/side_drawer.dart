import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/firebase%20functions/firebase_services.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/provider.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  _SideDrawerState createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  @override
  void initState() {
    super.initState();
    fetchUserProfile(context);
  }

  Future<void> fetchUserProfile(BuildContext context) async {
    // Fetch user profile using the ProfileProvider instead of UserProfileProvider
    await Provider.of<ProfileProvider>(context, listen: false).fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return SafeArea(
      bottom: true,
      child: Scaffold(
        backgroundColor: AppColors.secondary,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.secondary,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: AppColors.white,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            left: 15.0.w,
            right: 15.0.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Center(
              //   child: profileProvider.isFetchingImage
              //       ? Shimmer.fromColors(
              //           baseColor: Colors.grey[300]!,
              //           highlightColor: Colors.grey[100]!,
              //           child: CircleAvatar(
              //             radius: 70.r,
              //             backgroundColor: Colors.grey[300],
              //           ),
              //         )
              //       : CircleAvatar(
              //           radius: 70.r,
              //           backgroundImage: profileProvider.pickedImage != null
              //               ? FileImage(profileProvider.pickedImage!)
              //               : profileProvider.imageUrl.isNotEmpty
              //                   ? NetworkImage(profileProvider.imageUrl)
              //                   : null, // No image if the URL is empty
              //           backgroundColor: Colors.transparent,
              //           child: profileProvider.imageUrl.isEmpty &&
              //                   profileProvider.pickedImage == null
              //               ? CircleAvatar(
              //                   radius: 60.r,
              //                   child: Icon(
              //                     Icons.person,
              //                     size: 60.w,
              //                     color:
              //                         Colors.grey, // Customize the icon color
              //                   ),
              //                 )
              //               : null, // Show the image or null when loaded
              //         ),
              // ),

              Center(
                child: profileProvider.isFetchingImage
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundColor: Colors.grey[300],
                        ),
                      )
                    : CircleAvatar(
                        radius: 70.r,
                        backgroundImage: profileProvider.imageUrl.isNotEmpty
                            ? NetworkImage(profileProvider.imageUrl)
                            : null, // Display image from fetchUserData
                        backgroundColor: Colors.transparent,
                        child: profileProvider.imageUrl.isEmpty
                            ? CircleAvatar(
                                radius: 60,
                                child: Icon(
                                  Icons.person,
                                  size: 30.w,
                                  color: Colors.black,
                                ),
                              )
                            : null,
                      ),
              ),
              10.0.ph,
              Center(
                child: Text(
                  profileProvider.usernameController.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              60.0.ph,
              MenuItems(
                icon: Icons.person_2_outlined,
                text: 'Profile',
                onTap: () {
                  Navigator.pushReplacementNamed(context, RoutesName.profile);
                },
              ),
              30.0.ph,
              MenuItems(
                icon: Icons.notification_add_outlined,
                text: 'Notifications',
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, RoutesName.notification);
                },
              ),
              30.0.ph,
              MenuItems(
                icon: Icons.contacts,
                text: 'Contacts',
                onTap: () {
                  Navigator.pushReplacementNamed(context, RoutesName.addNumber);
                },
              ),
              100.ph,
              InkWell(
                onTap: () {
                  FirebaseFunctions.logoutFunction(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColors.white,
                    ),
                    borderRadius: BorderRadius.circular(6.0.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10.0.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.logout_outlined,
                          color: AppColors.white,
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 18.0.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItems extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MenuItems({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.white,
          ),
          borderRadius: BorderRadius.circular(6.0.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: AppColors.white,
                  ),
                  15.0.pw,
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 18.0.sp,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_sharp,
                color: AppColors.white,
                size: 17,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
