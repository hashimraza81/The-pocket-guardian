import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/bottom_round_clipper.dart';
import 'package:gentech/utils/reused_button.dart';

class LoginOrSignup extends StatefulWidget {
  const LoginOrSignup({super.key});

  @override
  State<LoginOrSignup> createState() => _LoginOrSignupState();
}

class _LoginOrSignupState extends State<LoginOrSignup> {
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
                    AppImages.login,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              60.ph,
              ReusedButton(
                text: 'Login',
                onPressed: () {
                  Navigator.pushReplacementNamed(context, RoutesName.signin);
                },
                colorbg: AppColors.secondary,
                colortext: AppColors.white,
              ),
              20.ph,
              ReusedButton(
                text: 'Create an account',
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.signup);
                },
                colorbg: AppColors.white,
                colortext: AppColors.secondary,
                bordercolor: AppColors.secondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
