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
              child: SvgPicture.asset(AppImages.bottomhome),
            ),
            GestureDetector(
              onTap: () {
                TrackingBottomBarProvider.changeIndex(1, context);
              },
              child: SvgPicture.asset(AppImages.bell),
            ),
          ],
        );
      }),
    );
  }
}
