import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/places_provider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/contact_listview.dart';
import 'package:gentech/utils/custom_bottom_bar.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/pin_Location.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/view/To%20Be%20Tracked/set_gps_screen.dart';
import 'package:gentech/view/To%20Be%20Tracked/side_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    fetchUserProfile(context);

    final placesProvider =
        Provider.of<LocationPlacesProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      placesProvider.startTrackingLocation(context);
    });
  }

  Future<void> fetchUserProfile(BuildContext context) async {
    await Provider.of<ProfileProvider>(context, listen: false).fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

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
                    ],
                  ),
                  30.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ReusedContainer(
                        image: AppImages.unlockphone,
                        text: 'Unlock Phone',
                        onTap: () => Navigator.pushNamed(
                            context, RoutesName.unlockphone),
                      ),
                      gpsContainer(
                        image: AppImages.gpslocation,
                        text: 'GPS location',
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SetGpsScreen()));
                        },
                      ),
                    ],
                  ),
                  24.ph,
                  const PlacesSearchScreen(),
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
                  ReusedButton(
                    text: "Add Numbers",
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.addNumber);
                    },
                    colorbg: AppColors.secondary,
                    colortext: AppColors.white,
                  ),
                  10.ph,
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
          borderRadius: BorderRadius.circular(10.0.r),
          color: AppColors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0.h,
            horizontal: 10.0.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(image),
              11.0.ph,
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
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

class gpsContainer extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback onTap;

  const gpsContainer({
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
          borderRadius: BorderRadius.circular(10.0.r),
          color: AppColors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0.h,
            horizontal: 12.0.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(image),
              11.0.ph,
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
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
