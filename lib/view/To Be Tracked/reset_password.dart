import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/utils/reused_text_field.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confrimpasswordController = TextEditingController();
  // String? _passwordError;

  // void _resetPassword(String password) async {
  //   try {
  //     User? user = FirebaseAuth.instance.currentUser;
  //     await user!.updatePassword(password);
  //     _showSuccessDialog(context);
  //   } catch (e) {
  //     setState(() {
  //       _passwordError = 'Error updating password: ${e.toString()}';
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.sccafold,
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0.w,
                vertical: 100.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CustomText(
                      text: 'New Pasword',
                      size: 28.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      familyFont: 'Montserrat',
                    ),
                  ),
                  100.ph,
                  CustomText(
                    text: 'Enter New Password',
                    size: 16.sp,
                    color: AppColors.grey3,
                    fontWeight: FontWeight.w500,
                    familyFont: 'Montserrat',
                  ),
                  10.ph,
                  CustomTextField(
                    controller: passwordController,
                    text: '******',
                    iconData: Icons.mail_outline,
                    toHide: true,
                  ),
                  10.ph,
                  CustomText(
                    text: 'Confirm Password',
                    size: 16.sp,
                    color: AppColors.grey3,
                    fontWeight: FontWeight.w500,
                    familyFont: 'Montserrat',
                  ),
                  10.ph,
                  CustomTextField(
                    controller: confrimpasswordController,
                    text: '******',
                    iconData: Icons.mail_outline,
                    toHide: true,
                  ),
                  20.ph,
                  Center(
                    child: ReusedButton(
                      text: 'Confirm',
                      onPressed: () {
                        _showSuccessDialog(context);
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
      ),
    );
  }
}

void _showSuccessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: SizedBox(
          width: 300.w,
          height: 300.h,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImages.resetComplete),
              20.ph,
              Text(
                'Reset Password Successful',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color(0xFF2C2C2C),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Montserrat',
                ),
              ),
              10.ph,
              Text(
                'Please wait. You will be directed\nto the homepage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF2C2C2C),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                ),
              ),
              20.ph,
              const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    },
  );

  Timer(const Duration(seconds: 2), () {
    Navigator.of(context).pop(); // Close the dialog
    Navigator.pushReplacementNamed(context, RoutesName.signin);
  });
}
