import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/bottom_round_clipper.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:provider/provider.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.sccafold,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: 524.w,
                  height: 484.h,
                  child: ClipPath(
                    clipper: BottomRoundClipper(),
                    child: Image.asset(
                      AppImages.splash2,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                50.ph,
                CustomText(
                  text: 'CREATE WITH',
                  size: 22.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  familyFont: 'Montserrat',
                ),
                20.ph,
                ReusedButton(
                  text: 'Track',
                  onPressed: () {
                    Provider.of<UserChoiceProvider>(context, listen: false)
                        .setUserChoice('Track');
                    Navigator.pushNamed(
                        context, RoutesName.loginOrSignup);
                  },
                  colorbg: AppColors.secondary,
                  colortext: AppColors.white,
                ),
                15.ph,
                ReusedButton(
                  text: 'Tracking',
                  onPressed: () {
                    Provider.of<UserChoiceProvider>(context, listen: false)
                        .setUserChoice('Tracking');
                    Navigator.pushNamed(
                        context, RoutesName.loginOrSignup);
                  },
                  colorbg: AppColors.white,
                  colortext: AppColors.secondary,
                  bordercolor: AppColors.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
