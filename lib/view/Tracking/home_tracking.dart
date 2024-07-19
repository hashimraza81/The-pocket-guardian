import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/contact_listview.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/view/To%20Be%20Tracked/side_drawer.dart';
import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
import 'package:provider/provider.dart';

class HomeTracking extends StatefulWidget {
  const HomeTracking({super.key});

  @override
  State<HomeTracking> createState() => _HomeTrackingState();
}

class _HomeTrackingState extends State<HomeTracking> {
  @override
  Widget build(BuildContext context) {
    return const ZoomDrawer(
      menuScreen: SideDrawer(),
      mainScreen: MainScreen(),
      showShadow: true,
      drawerShadowsBackgroundColor: AppColors.secondary,
      menuBackgroundColor: AppColors.secondary,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchProfileImage(context);
  }

  Future<void> fetchProfileImage(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userRole =
          Provider.of<UserChoiceProvider>(context, listen: false).userChoice;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(userRole == 'Track' ? 'trackUsers' : 'trackingUsers')
          .doc(user.uid)
          .get();

      setState(() {
        profileImageUrl = userDoc['imageUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          ZoomDrawer.of(context)!.toggle();
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
                          Navigator.pushNamed(
                            context,
                            RoutesName.profile,
                          );
                        },
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundImage: profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl)
                              : const AssetImage(AppImages.men)
                                  as ImageProvider,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                  30.ph,
                  Container(
                    height: 160.0.h,
                    width: 360.0.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      image: DecorationImage(
                        image: const AssetImage(AppImages.home),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.white.withOpacity(0.9), BlendMode.dstATop),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.0.h,
                        horizontal: 15.0.w,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'When to us the Pocket Guardian?',
                              size: 16.sp,
                              familyFont: 'Montserrat',
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
                            ),
                            5.ph,
                            CustomText(
                              text:
                                  '• To monitor the safety of a friend, colleague\n  or loved one',
                              size: 14.sp,
                              familyFont: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                            2.ph,
                            CustomText(
                              text:
                                  '• When working alone in an isolated or\n  dangerous environment',
                              size: 14.sp,
                              familyFont: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  24.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ReusedContainer(
                        image: AppImages.unlockphone,
                        text: 'Unlock Phone',
                        onTap: () => Navigator.pushNamed(
                            context, RoutesName.unlockphone),
                      ),
                      ReusedContainer(
                        image: AppImages.gpslocation,
                        text: 'GPS location',
                        onTap: () => Navigator.pushNamed(
                            context, RoutesName.trackinglocation),
                      ),
                    ],
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

// ignore: must_be_immutable
class ReusedContainer extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback onTap;

  const ReusedContainer({
    super.key,
    required this.image,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 33.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(image),
              11.0.ph,
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  fontFamily: 'Montserrat',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
