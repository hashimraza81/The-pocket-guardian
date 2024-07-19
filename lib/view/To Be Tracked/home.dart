import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/profile_Provider.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/contact_listview.dart';
import 'package:gentech/utils/custom_bottom_bar.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/pin_Location.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/view/To%20Be%20Tracked/set_gps_screen.dart';
import 'package:gentech/view/To%20Be%20Tracked/side_drawer.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    fetchUserProfile(context);
  }

  Future<void> fetchUserProfile(BuildContext context) async {
    String userRole =
        Provider.of<UserChoiceProvider>(context, listen: false).userChoice;

    await Provider.of<UserProfileProvider>(context, listen: false)
        .fetchUserProfile(context, userRole);
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
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
                          Navigator.pushNamed(context, RoutesName.profile);
                        },
                        child: CircleAvatar(
                          radius: 30.r,
                          backgroundImage:
                              userProfileProvider.profileImageUrl.isNotEmpty
                                  ? NetworkImage(
                                      userProfileProvider.profileImageUrl)
                                  : const AssetImage(AppImages.men)
                                      as ImageProvider,
                          backgroundColor: Colors.transparent,
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
                                  builder: (context) => const SetGpsScreen()));
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
                  const PinLocation(),
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
                  20.ph,
                  Center(
                    child: ReusedButton(
                      text: "Add Numbers",
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesName.addNumber);
                      },
                      colorbg: AppColors.secondary,
                      colortext: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomBar(),
      ),
    );
  }
}
