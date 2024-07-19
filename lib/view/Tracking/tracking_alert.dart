import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';

class TrackingAlert extends StatefulWidget {
  const TrackingAlert({super.key});

  @override
  State<TrackingAlert> createState() => _TrackingAlertState();
}

class _TrackingAlertState extends State<TrackingAlert> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.sccafold,
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              top: 460.h,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0.h,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SvgPicture.asset(AppImages.bulb),
                        10.0.ph,
                        CustomText(
                          text: 'Uh oh',
                          size: 26.sp,
                          color: AppColors.primary,
                          familyFont: 'Montserrat',
                          fontWeight: FontWeight.w700,
                        ),
                        10.0.ph,
                        Text(
                          'Something went wrong. It looks like\nthere has been an accident causing the\nstatus to stop',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.primary,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        10.0.ph,
                        ReusedButton(
                          text: 'Check Status',
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RoutesName.trackinglocation);
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
          ],
        ),
      ),
    );
  }
}
