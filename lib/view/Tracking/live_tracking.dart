import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/provider/tracking_bottom_bar_Provider.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
import 'package:provider/provider.dart';

class LiveTracking extends StatefulWidget {
  const LiveTracking({super.key});

  @override
  _LiveTrackingState createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TrackingBottomBarProvider(),
      child: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            title: CustomText(
              text: 'Live Tracking',
              size: 24.0.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              familyFont: 'Montserrat',
            ),
          ),
          body: Stack(
            children: [
              // Map Placeholder
              Positioned.fill(
                child: Image.asset(
                  AppImages.map, // Use a placeholder image or a map widget here
                  fit: BoxFit.cover,
                ),
              ),
              // GPS Location Pin
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 50,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: const TrackingBottomBar(),
        ),
      ),
    );
  }
}
