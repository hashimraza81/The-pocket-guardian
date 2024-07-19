import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  TextEditingController verificationCodeController = TextEditingController();
  String? _verificationError;

  void _verifyCode(String code) {
    // Implement code verification logic here
    // For simplicity, assume code '1234' is correct
    if (code == '1234') {
      Navigator.pushNamed(context, RoutesName.resetPassword);
    } else {
      setState(() {
        _verificationError = 'Invalid verification code';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.sccafold,
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
                      text: 'Verification',
                      size: 28.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      familyFont: 'Montserrat',
                    ),
                  ),
                  75.ph,
                  Center(
                    child: CustomText(
                      text: 'We have sent an OTP code to your email',
                      size: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                      familyFont: 'Montserrat',
                    ),
                  ),
                  Center(
                    child: CustomText(
                      text: 'exa****@gmail.com. Enter the code below.',
                      size: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                      familyFont: 'Montserrat',
                    ),
                  ),
                  48.ph,
                  Center(
                    child: CustomText(
                      text: 'Enter Verification Code',
                      size: 14.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      familyFont: 'Montserrat',
                    ),
                  ),
                  30.ph,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      VerificationCode(controller: verificationCodeController),
                      30.pw,
                      VerificationCode(controller: verificationCodeController),
                      30.pw,
                      VerificationCode(controller: verificationCodeController),
                      30.pw,
                      VerificationCode(controller: verificationCodeController),
                    ],
                  ),
                  60.ph,
                  if (_verificationError != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          _verificationError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  Center(
                    child: ReusedButton(
                      text: 'Send',
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesName.resetPassword);
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

class VerificationCode extends StatelessWidget {
  final TextEditingController controller;

  const VerificationCode({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30.r,
      backgroundColor: AppColors.white,
      child: Padding(
        padding: EdgeInsets.all(8.0.r),
        child: TextField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: TextStyle(
            fontSize: 25.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.r),
              borderSide: const BorderSide(width: 2, color: AppColors.primary),
            ),
            hintText: '#',
            hintStyle: TextStyle(
              fontSize: 25.sp,
              color: AppColors.grey4,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ),
    );
  }
}
