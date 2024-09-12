import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/firebase%20functions/firebase_services.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/utils/reused_text_field.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final bool _showSuccessMessage = false;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

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
                vertical: 68.0.h,
                horizontal: 16.0.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CustomText(
                      text: 'SIGN IN',
                      size: 42.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      familyFont: 'Montserrat',
                    ),
                  ),
                  50.ph,
                  CustomText(
                    text: 'Email',
                    size: 16.sp,
                    familyFont: 'Montserrat',
                    color: AppColors.grey3,
                    fontWeight: FontWeight.w500,
                  ),
                  10.ph,
                  CustomTextField(
                    controller: emailController,
                    text: 'Email',
                    iconData: Icons.mail_outline,
                    toHide: false,
                    focusNode: emailFocusNode,
                    nextFocusNode: passwordFocusNode,
                  ),
                  24.ph,
                  CustomText(
                    text: 'Password',
                    size: 16.sp,
                    familyFont: 'Montserrat',
                    color: AppColors.grey3,
                    fontWeight: FontWeight.w500,
                  ),
                  24.ph,
                  CustomTextField(
                    controller: passwordController,
                    text: 'Password',
                    iconData: Icons.password_outlined,
                    toHide: true,
                    focusNode: passwordFocusNode,
                  ),
                  24.ph,
                  Center(
                    child: ReusedButton(
                      text: 'Login',
                      onPressed: () {
                        // Call the sign-in function
                        FirebaseFunctions.signInFunction(
                          context,
                          emailController.text.trim(),
                          passwordController.text,
                        );
                      },
                      colorbg: AppColors.secondary,
                      colortext: AppColors.white,
                    ),
                  ),
                  if (_showSuccessMessage) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: CustomText(
                        text: 'Logged in successfully',
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                  21.ph,
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.signup);
                      },
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Don’t have an account?",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primary,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: "Sign up",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primary,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  5.ph,
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutesName.forgotPassword);
                      },
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.secondary,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
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
