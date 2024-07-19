import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/firebase%20functions/firebase_services.dart';
import 'package:gentech/provider/profile_Provider.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:provider/provider.dart';

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
        backgroundColor: AppColors.secondary,
        body: Padding(
          padding: EdgeInsets.only(
            top: 30.0.h,
            left: 15.0.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60.r,
                  backgroundImage:
                      userProfileProvider.profileImageUrl.isNotEmpty
                          ? NetworkImage(userProfileProvider.profileImageUrl)
                          : const AssetImage(AppImages.men) as ImageProvider,
                  backgroundColor: Colors.transparent,
                ),
                10.0.ph,
                Text(
                  userProfileProvider.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
                60.0.ph,
                MenuItems(
                  icon: Icons.person_2_outlined,
                  text: 'Profile',
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.profile);
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
                    Navigator.pushReplacementNamed(
                        context, RoutesName.addNumber);
                  },
                ),
                350.0.ph,
                MenuItems(
                  icon: Icons.logout_outlined,
                  text: 'Logout',
                  onTap: () {
                    FirebaseFunctions.logoutFunction(context);
                  },
                )
              ],
            ),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
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
    );
  }
}
