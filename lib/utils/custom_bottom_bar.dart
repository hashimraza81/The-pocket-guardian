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
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      width: double.infinity,
      height: 110.0.h,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 35.0.h),
            child: Container(
              height: 75.0.h,
              width: double.infinity,
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
                      child: SvgPicture.asset(AppImages.bell),
                    ),
                  ],
                );
              }),
            ),
          ),
          Positioned(
            top: 10.0.h,
            left: 150.0.w,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.alert);
              },
              child: CircleAvatar(
                radius: 50.0.r,
                backgroundColor: AppColors.secondary,
                child: CustomText(
                  text: 'Alert',
                  size: 22.0.sp,
                  color: AppColors.white,
                  familyFont: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
