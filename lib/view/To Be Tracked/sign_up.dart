import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/firebase%20functions/firebase_services.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/phone_number_field.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/utils/reused_text_field.dart';
import 'package:gentech/utils/upload_profile_photo.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phonenumberController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();
  String? imageUrl;
  bool isLoading = false;

  Future<void> pickImage() async {
    try {
      XFile? res = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (res != null) {
        await uploadImageToFirebase(File(res.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red,
          content: Text('Failed to pick image: $e'),
        ),
      );
    }
  }

  Future<void> uploadImageToFirebase(File image) async {
    setState(() {
      isLoading = true;
    });
    try {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("images/${DateTime.now().microsecondsSinceEpoch}.png");
      await reference.putFile(image).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.primary,
            duration: Duration(seconds: 2),
            content: Text('Upload Successfully:'),
          ),
        );
      });
      imageUrl = await reference.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.red,
          content: Text('Failed to upload image: $e'),
        ),
      );
    }
    setState(() {
      isLoading = false;
    });
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
                vertical: 68.0.h,
                horizontal: 16.0.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CustomText(
                      text: 'SIGN UP',
                      size: 42.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      familyFont: 'Montserrat',
                    ),
                  ),
                  50.ph,
                  CustomText(
                    text: 'Add Profile Photo',
                    size: 16.sp,
                    familyFont: 'Montserrat',
                    color: AppColors.grey3,
                    fontWeight: FontWeight.w500,
                  ),
                  10.ph,
                  if (isLoading)
                    const Positioned(
                      top: 70,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: pickImage,
                    child: imageUrl == null
                        ? const uploadProfile()
                        : Center(
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl!)
                                  : null,
                              child: imageUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 50,
                                      color: Colors.grey,
                                    )
                                  : null,
                            ),
                          ),
                  ),
                  10.ph,
                  CustomText(
                    text: 'User Name',
                    size: 16.sp,
                    familyFont: 'Montserrat',
                    color: AppColors.grey3,
                    fontWeight: FontWeight.w500,
                  ),
                  10.ph,
                  CustomTextField(
                    controller: usernameController,
                    text: 'Name',
                    iconData: Icons.person_2_outlined,
                    toHide: false,
                  ),
                  10.ph,
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
                  ),
                  10.ph,
                  CustomText(
                    text: 'Password',
                    size: 16.sp,
                    familyFont: 'Montserrat',
                    color: AppColors.grey3,
                    fontWeight: FontWeight.w500,
                  ),
                  10.ph,
                  CustomTextField(
                    controller: passwordController,
                    text: 'Password',
                    iconData: Icons.password_outlined,
                    toHide: true,
                  ),
                  10.ph,
                  CustomText(
                    text: 'Confirm Password',
                    size: 16.sp,
                    familyFont: 'Montserrat',
                    color: AppColors.grey3,
                    fontWeight: FontWeight.w500,
                  ),
                  10.ph,
                  CustomTextField(
                    controller: confirmPasswordController,
                    text: 'Password',
                    iconData: Icons.password_outlined,
                    toHide: true,
                  ),
                  10.ph,
                  CustomText(
                    text: 'Phone Number',
                    size: 16.sp,
                    familyFont: 'Montserrat',
                    color: AppColors.grey3,
                    fontWeight: FontWeight.w500,
                  ),
                  10.ph,
                  PhoneNumberField(
                    controller: phonenumberController,
                  ),
                  20.ph,
                  Center(
                    child: ReusedButton(
                      text: 'Sign Up',
                      onPressed: () {
                        FirebaseFunctions.signUpFunction(
                          context,
                          emailController.text.toString(),
                          passwordController.text.toString(),
                          usernameController.text.toString(),
                          phonenumberController.text.toString(),
                          imageUrl,
                        );
                      },
                      colorbg: AppColors.secondary,
                      colortext: AppColors.white,
                    ),
                  ),
                  21.ph,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('SignUp'),
          content: const Text('User SignUp Successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, RoutesName.signin);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
