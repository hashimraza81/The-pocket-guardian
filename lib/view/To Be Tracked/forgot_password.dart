import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/utils/reused_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  String? _emailError;
  String? _message; // State variable to manage success message

  Future<void> _sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      setState(() {
        _message = 'Password reset email sent to $email';
        _emailError = null; // Reset any previous errors
      });

      // Delay navigation to sign-in screen after 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      // Navigate back to sign-in screen
      Navigator.popUntil(context, ModalRoute.withName(RoutesName.signin));
    } catch (e) {
      setState(() {
        _emailError = 'Error sending reset email: ${e.toString()}';
        _message = null; // Clear success message if there was an error
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
                      text: 'Forgot Password',
                      size: 28.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      familyFont: 'Montserrat',
                    ),
                  ),
                  100.ph,
                  CustomText(
                    text: 'Enter Email Address',
                    size: 16.sp,
                    color: AppColors.grey3,
                    fontWeight: FontWeight.w500,
                    familyFont: 'Montserrat',
                  ),
                  10.ph,
                  CustomTextField(
                    controller: emailController,
                    text: 'example@gmail.com',
                    iconData: Icons.mail_outline,
                    toHide: false,
                  ),
                  20.ph,
                  Center(
                    child: ReusedButton(
                      text: 'Send',
                      onPressed: () {
                        _sendPasswordResetEmail(emailController.text.trim());
                      },
                      colorbg: AppColors.secondary,
                      colortext: AppColors.white,
                    ),
                  ),
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          _emailError!,
                          style: const TextStyle(color: AppColors.red),
                        ),
                      ),
                    ),
                  if (_message != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          _message!,
                          style: const TextStyle(color: Colors.green),
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
