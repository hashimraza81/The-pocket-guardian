import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/contact_listview.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/view/To%20Be%20Tracked/side_drawer.dart';
import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
import 'package:gentech/view/Tracking/tracking_location.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/provider.dart';

class HomeTracking extends StatefulWidget {
  const HomeTracking({super.key});

  @override
  State<HomeTracking> createState() => _HomeTrackingState();
}

class _HomeTrackingState extends State<HomeTracking> {
  @override
  void initState() {
    super.initState();
    fetchUserProfile(context);
  }

  Future<void> fetchUserProfile(BuildContext context) async {
    await Provider.of<ProfileProvider>(context, listen: false).fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    print(profileProvider.imageUrl);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.sccafold,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 17.0.w,
                vertical: 17.0.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SideDrawer()));
                        },
                        icon: const Icon(
                          Icons.menu,
                          size: 40.0,
                        ),
                      ),
                      Image.asset(
                        AppImages.logo,
                        height: 40.h,
                        width: 125.w,
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.profile);
                        },
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
                                radius: 30.r,
                                backgroundImage:
                                    profileProvider.imageUrl.isNotEmpty
                                        ? NetworkImage(profileProvider.imageUrl)
                                        : null,
                                backgroundColor: Colors.transparent,
                                child: profileProvider.imageUrl.isEmpty
                                    ? Icon(
                                        Icons.person,
                                        size: 30.w,
                                        color: Colors.black,
                                      )
                                    : null,
                              ),
                      )

                      // InkWell(
                      //   onTap: () {
                      //     Navigator.pushNamed(context, RoutesName.profile);
                      //   },
                      //   child: profileProvider.isFetchingImage
                      //       ? Shimmer.fromColors(
                      //           baseColor: Colors.grey[300]!,
                      //           highlightColor: Colors.grey[100]!,
                      //           child: CircleAvatar(
                      //             radius: 30.r,
                      //             backgroundColor: Colors.grey[300],
                      //           ),
                      //         )
                      //       : CircleAvatar(
                      //           radius: 30.r,
                      //           backgroundImage: profileProvider.pickedImage !=
                      //                   null
                      //               ? FileImage(profileProvider.pickedImage!)
                      //               : profileProvider.imageUrl.isNotEmpty
                      //                   ? NetworkImage(profileProvider.imageUrl)
                      //                   : null, // No image if URL is empty
                      //           backgroundColor: Colors.transparent,
                      //           child: profileProvider.imageUrl.isEmpty &&
                      //                   profileProvider.pickedImage == null
                      //               ? CircleAvatar(
                      //                   radius: 60,
                      //                   child: Icon(
                      //                     Icons.person,
                      //                     size: 30.w,
                      //                     color: Colors.black,
                      //                   ),
                      //                 )
                      //               : null,
                      //         ),
                      // )
                    ],
                  ),
                  30.ph,
                  Container(
                    width: 360.w,
                    height: 75.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 19.0.h,
                        horizontal: 15.w,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TrackingLocation(
                                imageUrl: null,
                                phonenumber: null,
                                fromNotificationRoute: false,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              AppImages.gps,
                            ),
                            12.pw,
                            CustomText(
                              text: 'GPS location',
                              size: 14.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              familyFont: 'Montserrat',
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  24.ph,
                  CustomText(
                    text: 'Contacts',
                    size: 22.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    familyFont: 'Montserrat',
                  ),
                  20.0.ph,
                  const ContactListview(),
                  20.0.ph,
                  ReusedButton(
                    text: 'Add Number',
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.addNumber);
                    },
                    colorbg: AppColors.secondary,
                    colortext: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const TrackingBottomBar(),
      ),
    );
  }
}
