import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/bottom_round_clipper.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  void initState() {
    super.initState();
    // Schedule navigation to the next screen after a 10 second delay
    Future.delayed(const Duration(seconds: 10), () {
      Navigator.pushNamed(
          context,
          RoutesName
              .splashscreen); // Replace SplashScreen with your target screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.sccafold,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(
                width: 524.w,
                height: 484.h,
                child: ClipPath(
                  clipper: BottomRoundClipper(),
                  child: Image.asset(
                    AppImages.splash,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              76.ph,
              Image.asset(AppImages.logo),
            ],
          ),
        ),
      ),
    );
  }
}
