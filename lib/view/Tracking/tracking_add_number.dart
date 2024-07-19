import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/view/To%20Be%20Tracked/side_drawer.dart';

class TrackingAddNumber extends StatefulWidget {
  const TrackingAddNumber({super.key});

  @override
  State<TrackingAddNumber> createState() => _TrackingAddNumberState();
}

class _TrackingAddNumberState extends State<TrackingAddNumber> {
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

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
  });

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
                              context, RoutesName.trackingProfile);
                        },
                        child: CircleAvatar(
                          radius: 30.r,
                          child: ClipOval(
                            child: Image.asset(
                              AppImages.profile,
                              fit: BoxFit.cover,
                              height: 60.h,
                              width: 60.w,
                            ),
                          ),
                        ),
                      )
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
                  ReusedButton(
                    text: 'Add Number',
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.addNumber);
                    },
                    colorbg: AppColors.secondary,
                    colortext: AppColors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
