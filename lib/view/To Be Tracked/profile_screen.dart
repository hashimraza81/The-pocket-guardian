import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/utils/custom_bottom_bar.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/utils/reused_text_field.dart';
import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  String imageUrl = '';
  String userId = '';
  bool isUploading = false; // Track image upload state
  bool showUploadSuccess = false; // Track upload success state

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      final userChoiceProvider =
          Provider.of<UserChoiceProvider>(context, listen: false);
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(userChoiceProvider.userChoice == 'Track'
              ? 'trackUsers'
              : 'trackingUsers')
          .doc(user.uid)
          .get();
      setState(() {
        usernameController.text = userDoc['name'];
        emailController.text = userDoc['email'];
        phonenumberController.text = userDoc['phonenumber'];
        imageUrl = userDoc['imageUrl'];
      });
    }
  }

  Future<void> updateUserData() async {
    if (userId.isNotEmpty) {
      final userChoiceProvider =
          Provider.of<UserChoiceProvider>(context, listen: false);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update email in Firebase Authentication
        if (emailController.text != user.email) {
          try {
            await user.verifyBeforeUpdateEmail(emailController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Email verification sent. Please verify the new email before it can be updated.')),
            );
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating email: ${e.message}')),
            );
            return;
          }
        }

        // if (userId.isNotEmpty) {
        //   final userChoiceProvider =
        //       Provider.of<UserChoiceProvider>(context, listen: false);

        //   User? user = FirebaseAuth.instance.currentUser;
        //   if (user != null) {
        //     // Update email in Firebase Authentication
        //     if (emailController.text != user.email) {
        //       try {
        //         await user.verifyBeforeUpdateEmail(emailController.text);
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           const SnackBar(
        //               content: Text(
        //                   'Email verification sent. Please verify the new email before it can be updated.')),
        //         );
        //       } on FirebaseAuthException catch (e) {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(content: Text('Error updating email: ${e.message}')),
        //         );
        //         return;
        //       }
        //     }
        // if (userId.isNotEmpty) {
        //   final userChoiceProvider =
        //       Provider.of<UserChoiceProvider>(context, listen: false);

        //   User? user = FirebaseAuth.instance.currentUser;
        //   if (user != null) {
        //     // Update email in Firebase Authentication
        //     if (emailController.text != user.email) {
        //       try {
        //         await user.updateEmail(emailController.text);
        //         await user.sendEmailVerification(); // Send verification email
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           const SnackBar(
        //               content: Text(
        //                   'Email updated successfully. Please check your new email for verification.')),
        //         );
        //       } on FirebaseAuthException catch (e) {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(content: Text('Error updating email: ${e.message}')),
        //         );
        //         return;
        //       }
        //     }

        // Update password in Firebase Authentication
        if (passwordController.text.isNotEmpty) {
          try {
            await user.updatePassword(passwordController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password updated successfully')),
            );
          } on FirebaseAuthException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating password: ${e.message}')),
            );
            return;
          }
        }

        // Update user data in Firestore
        await FirebaseFirestore.instance
            .collection(userChoiceProvider.userChoice == 'Track'
                ? 'trackUsers'
                : 'trackingUsers')
            .doc(userId)
            .update({
          'name': usernameController.text,
          'email': emailController.text,
          'phonenumber': phonenumberController.text,
          'imageUrl': imageUrl,
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      isUploading = true;
    });

    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Delete previous image if it exists
      if (imageUrl.isNotEmpty) {
        try {
          await FirebaseStorage.instance.refFromURL(imageUrl).delete();
        } catch (e) {
          print('Error deleting previous image: $e');
        }
      }

      // Upload new image to Firebase Storage and get the download URL
      Reference storageRef =
          FirebaseStorage.instance.ref().child('images').child('$userId.png');
      await storageRef.putFile(imageFile);
      String newImageUrl = await storageRef.getDownloadURL();

      // Update imageUrl in Firestore
      final userChoiceProvider =
          Provider.of<UserChoiceProvider>(context, listen: false);
      await FirebaseFirestore.instance
          .collection(userChoiceProvider.userChoice == 'Track'
              ? 'trackUsers'
              : 'trackingUsers')
          .doc(userId)
          .update({'imageUrl': newImageUrl});

      // Update state to refresh the UI and show success message
      setState(() {
        imageUrl = newImageUrl;
        isUploading = false; // Hide uploading indicator
        showUploadSuccess = true; // Show upload success message
      });

      // Hide success message after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          showUploadSuccess = false;
        });
      });
    } else {
      print('No image selected.');
      setState(() {
        isUploading = false; // Hide uploading indicator if no image selected
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userChoiceProvider = Provider.of<UserChoiceProvider>(context);
    final userChoice = userChoiceProvider.userChoice;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.sccafold,
        resizeToAvoidBottomInset: true,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 25.0.h,
                    horizontal: 15.0.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 44.0.h,
                          width: 44.0.w,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              10.0.r,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      90.0.pw,
                      CustomText(
                        text: 'Profile',
                        size: 24.0.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        familyFont: 'Montserrat',
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 150.0.h,
                left: 15.0.w,
                right: 15.0.w,
                child: Container(
                  height: 500.0.h,
                  width: 360.0.w,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(40.0.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        63.ph,
                        CustomTextField(
                          controller: usernameController,
                          text: 'Name',
                          toHide: false,
                          iconData: Icons.edit,
                        ),
                        24.0.ph,
                        CustomTextField(
                          controller: emailController,
                          text: 'Email',
                          toHide: false,
                          iconData: Icons.edit,
                        ),
                        24.0.ph,
                        CustomTextField(
                          controller: passwordController,
                          text: '*****',
                          toHide: true,
                          iconData: Icons.edit,
                        ),
                        24.0.ph,
                        CustomTextField(
                          controller: phonenumberController,
                          text: 'Phone Number',
                          toHide: false,
                          iconData: Icons.edit,
                        ),
                        24.0.ph,
                        ReusedButton(
                          text: 'Update Profile',
                          onPressed: () {
                            updateUserData();
                          },
                          colorbg: AppColors.secondary,
                          colortext: AppColors.white,
                        ),
                        10.0.ph,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 80.0.h,
                left: 128.0.w,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _pickImage(ImageSource
                            .gallery); // Change ImageSource as needed
                      },
                      child: CircleAvatar(
                        radius: 60.0.r,
                        backgroundImage: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : const AssetImage(AppImages.profile)
                                as ImageProvider,
                        backgroundColor: Colors
                            .transparent, // Optional: Add a background color if needed
                      ),
                    ),
                    if (isUploading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black54,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    if (showUploadSuccess)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black54,
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 60.0,
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Profile picture\nuploaded',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Positioned(
                top: 165.0.h,
                left: 215.0.w,
                child: Container(
                  height: 27.0.h,
                  width: 27.0.w,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10.0.r),
                  ),
                  child: Icon(
                    Icons.edit_note,
                    color: AppColors.secondary,
                    size: 18.0.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: userChoice == 'Track'
            ? const CustomBottomBar()
            : const TrackingBottomBar(),
      ),
    );
  }
}
