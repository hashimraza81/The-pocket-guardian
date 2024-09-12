// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gentech/const/app_colors.dart';
// import 'package:gentech/extension/sizebox_extension.dart';
// import 'package:gentech/provider/user_choice_provider.dart';
// import 'package:gentech/utils/custom_bottom_bar.dart';
// import 'package:gentech/utils/custom_text_widget.dart';
// import 'package:gentech/utils/reused_button.dart';
// import 'package:gentech/utils/reused_text_field.dart';
// import 'package:gentech/view/Tracking/tracking_bottom_bar.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController phonenumberController = TextEditingController();
//   String imageUrl = '';
//   String userId = '';
//   bool isUploading = false; // Track image upload state
//   bool showUploadSuccess = false; // Track upload success state
//   bool isFetchingImage = true; // Initial state: fetching image
//   File? pickedImage;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // Get the user ID
//         userId = user.uid;

//         // Access the userChoiceProvider outside of the async context
//         final userChoiceProvider =
//             Provider.of<UserChoiceProvider>(context, listen: false);

//         // Choose the collection based on the user's choice (Track or Tracking)
//         String collectionPath = userChoiceProvider.userChoice == 'Track'
//             ? 'trackUsers'
//             : 'trackingUsers';

//         // Fetch the user document from Firestore
//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection(collectionPath)
//             .doc(user.uid)
//             .get();

//         if (userDoc.exists) {
//           setState(() {
//             // Update the controllers with the fetched data
//             usernameController.text = userDoc['name'] ?? '';
//             emailController.text = userDoc['email'] ?? '';
//             phonenumberController.text = userDoc['phonenumber'] ?? '';
//             imageUrl = userDoc['imageUrl'] ?? '';

//             // Stop the image loading shimmer after the image URL is fetched
//             isFetchingImage = false;
//           });
//         } else {
//           print('User document does not exist');
//           setState(() {
//             isFetchingImage = false; // Stop shimmer if no userDoc found
//           });
//         }
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//       setState(() {
//         isFetchingImage = false; // Stop shimmer in case of error
//       });
//     }
//   }

//   Future<void> updateUserData() async {
//     if (userId.isNotEmpty) {
//       final userChoiceProvider =
//           Provider.of<UserChoiceProvider>(context, listen: false);

//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         // Update email in Firebase Authentication
//         if (emailController.text != user.email) {
//           try {
//             await user.updateEmail(emailController.text);
//             await user.sendEmailVerification(); // Send verification email
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                   content: Text(
//                       'Email updated successfully. Please check your new email for verification.')),
//             );
//           } on FirebaseAuthException catch (e) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Error updating email: ${e.message}')),
//             );
//             return;
//           }
//         }

//         // Update password in Firebase Authentication
//         if (passwordController.text.isNotEmpty) {
//           try {
//             await user.updatePassword(passwordController.text);
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Password updated successfully')),
//             );
//           } on FirebaseAuthException catch (e) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Error updating password: ${e.message}')),
//             );
//             return;
//           }
//         }

//         // If a new image is picked, upload it to Firebase Storage
//         String newImageUrl = imageUrl; // Keep existing image URL
//         if (pickedImage != null) {
//           setState(() {
//             isUploading = true;
//           });

//           // Delete previous image if it exists
//           if (imageUrl.isNotEmpty) {
//             try {
//               await FirebaseStorage.instance.refFromURL(imageUrl).delete();
//             } catch (e) {
//               print('Error deleting previous image: $e');
//             }
//           }

//           // Upload new image to Firebase Storage
//           Reference storageRef = FirebaseStorage.instance
//               .ref()
//               .child('images')
//               .child('$userId.png');
//           await storageRef.putFile(pickedImage!);
//           newImageUrl = await storageRef.getDownloadURL();

//           setState(() {
//             isUploading = false; // Hide uploading indicator
//             showUploadSuccess = true; // Show upload success message
//           });

//           // Hide success message after 2 seconds
//           Future.delayed(const Duration(seconds: 2), () {
//             setState(() {
//               showUploadSuccess = false;
//             });
//           });
//         }

//         // Update user data in Firestore
//         await FirebaseFirestore.instance
//             .collection(userChoiceProvider.userChoice == 'Track'
//                 ? 'trackUsers'
//                 : 'trackingUsers')
//             .doc(userId)
//             .update({
//           'name': usernameController.text,
//           'email': emailController.text,
//           'phonenumber': phonenumberController.text,
//           'imageUrl': newImageUrl,
//         });

//         // Show a Snackbar indicating profile update success
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile updated successfully')),
//         );
//       }
//     }
//   }

//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         pickedImage = File(pickedFile.path); // Update picked image in UI
//       });
//     } else {
//       print('No image selected.');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userChoiceProvider = Provider.of<UserChoiceProvider>(context);
//     final userChoice = userChoiceProvider.userChoice;

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.sccafold,
//         resizeToAvoidBottomInset: true,
//         appBar: AppBar(
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Container(
//               height: 44.0.h,
//               width: 44.0.w,
//               decoration: BoxDecoration(
//                 color: AppColors.white,
//                 borderRadius: BorderRadius.circular(
//                   10.0.r,
//                 ),
//               ),
//               child: const Icon(
//                 Icons.arrow_back_ios,
//                 color: AppColors.primary,
//               ),
//             ),
//           ),
//           title: CustomText(
//             text: 'Profile',
//             size: 24.0.sp,
//             color: AppColors.primary,
//             fontWeight: FontWeight.w700,
//             familyFont: 'Montserrat',
//           ),
//           centerTitle: true,
//         ),
//         body: SizedBox(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 70.0.h,
//                 left: 15.0.w,
//                 right: 15.0.w,
//                 child: Container(
//                   height: 460.0.h,
//                   width: 360.0.w,
//                   decoration: BoxDecoration(
//                     color: AppColors.secondary.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(40.0.r),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 15.0.w),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           68.ph,
//                           CustomTextField(
//                             controller: usernameController,
//                             text: 'Name',
//                             toHide: false,
//                             iconData: Icons.edit,
//                           ),
//                           24.0.ph,
//                           CustomTextField(
//                             controller: emailController,
//                             text: 'Email',
//                             toHide: false,
//                             iconData: Icons.edit,
//                           ),
//                           24.0.ph,
//                           CustomTextField(
//                             controller: passwordController,
//                             text: '*****',
//                             toHide: true,
//                             iconData: Icons.edit,
//                           ),
//                           24.0.ph,
//                           CustomTextField(
//                             controller: phonenumberController,
//                             text: 'Phone Number',
//                             toHide: false,
//                             iconData: Icons.edit,
//                           ),
//                           24.0.ph,
//                           ReusedButton(
//                             text: 'Update Profile',
//                             onPressed: () {
//                               updateUserData();
//                             },
//                             colorbg: AppColors.secondary,
//                             colortext: AppColors.white,
//                           ),
//                           10.0.ph,
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 10.h,
//                 left: 128.0.w,
//                 child: Stack(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         _pickImage(ImageSource.gallery);
//                       },
//                       child: isFetchingImage ||
//                               isUploading // Show shimmer or image
//                           ? Shimmer.fromColors(
//                               baseColor: Colors.grey[300]!,
//                               highlightColor: Colors.grey[100]!,
//                               child: CircleAvatar(
//                                 radius: 60.0.r,
//                                 backgroundColor: Colors.grey[300],
//                               ),
//                             )
//                           : CircleAvatar(
//                               radius: 60.0.r,
//                               backgroundImage: pickedImage != null
//                                   ? FileImage(
//                                       pickedImage!) // Show picked image if available
//                                   : imageUrl.isNotEmpty
//                                       ? NetworkImage(imageUrl)
//                                       : null, // No image if the URL is empty
//                               backgroundColor: Colors.transparent,
//                               child: imageUrl.isEmpty && pickedImage == null
//                                   ? CircleAvatar(
//                                       radius: 60.0.r,
//                                       child: Icon(
//                                         Icons.person,
//                                         size: 60.0.r,
//                                         color: AppColors.grey3,
//                                       ),
//                                     )
//                                   : null,
//                             ),
//                     ),
//                     // if (isUploading)
//                     //   Positioned.fill(
//                     //     child: Container(
//                     //       color: Colors.black54,
//                     //       child: const Center(
//                     //         child: CircularProgressIndicator(),
//                     //       ),
//                     //     ),
//                     //   ),
//                     // if (showUploadSuccess)
//                     // Positioned.fill(
//                     //   child: Container(
//                     //     color: Colors.black54,
//                     //     child: const Center(
//                     //       child: Column(
//                     //         mainAxisAlignment: MainAxisAlignment.center,
//                     //         children: [
//                     //           Text(
//                     //             'Profile picture\nuploaded',
//                     //             textAlign: TextAlign.center,
//                     //             style: TextStyle(
//                     //               color: Colors.white,
//                     //               fontSize: 18.0,
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//               Positioned(
//                 top: 95.0.h,
//                 left: 210.0.w,
//                 child: Container(
//                   height: 27.0.h,
//                   width: 27.0.w,
//                   decoration: BoxDecoration(
//                     color: AppColors.white,
//                     borderRadius: BorderRadius.circular(10.0.r),
//                   ),
//                   child: Icon(
//                     Icons.edit_note,
//                     color: AppColors.secondary,
//                     size: 18.0.sp,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: userChoice == 'Track'
//             ? const CustomBottomBar()
//             : const TrackingBottomBar(),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gentech/const/app_colors.dart';
// import 'package:gentech/extension/sizebox_extension.dart';
// import 'package:gentech/provider/provider.dart';
// import 'package:gentech/utils/custom_bottom_bar.dart';
// import 'package:gentech/utils/reused_button.dart';
// import 'package:gentech/utils/reused_text_field.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';

// import '../../provider/user_choice_provider.dart';
// import '../../utils/snackbar.dart';
// import '../Tracking/tracking_bottom_bar.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final profileProvider = Provider.of<ProfileProvider>(context);
//     final userChoiceProvider = Provider.of<UserChoiceProvider>(context);
//     final userChoice = userChoiceProvider.userChoice;

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.sccafold,
//         // resizeToAvoidBottomInset: true,
//         appBar: AppBar(
//           backgroundColor: AppColors.sccafold,
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const Icon(
//               Icons.arrow_back_ios,
//               color: AppColors.primary,
//             ),
//           ),
//           title: Text(
//             'Profile',
//             style: TextStyle(
//               fontSize: 24.0.sp,
//               color: AppColors.primary,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 top: 100.0,
//                 left: 15,
//                 right: 15,
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: AppColors.secondary.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(40.0.r),
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 15.0.w,
//                           ),
//                           child: Column(
//                             // crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               68.ph,
//                               CustomTextField(
//                                 controller: profileProvider.usernameController,
//                                 text: 'Name',
//                                 toHide: false,
//                                 iconData: Icons.edit,
//                               ),
//                               24.ph,
//                               CustomTextField(
//                                 controller: profileProvider.emailController,
//                                 text: 'Email',
//                                 toHide: false,
//                                 iconData: Icons.edit,
//                               ),
//                               24.ph,
//                               CustomTextField(
//                                 controller: profileProvider.passwordController,
//                                 text: '*****',
//                                 toHide: true,
//                                 iconData: Icons.edit,
//                               ),
//                               24.ph,
//                               CustomTextField(
//                                 controller:
//                                     profileProvider.phonenumberController,
//                                 text: 'Phone Number',
//                                 toHide: false,
//                                 iconData: Icons.edit,
//                               ),
//                               24.ph,
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                   top: 10.0,
//                                   bottom: 20,
//                                 ),
//                                 child: ReusedButton(
//                                   text: 'Update Profile',
//                                   onPressed: () async {
//                                     bool success =
//                                         await profileProvider.updateUserData();
//                                     if (success) {
//                                       showTopSnackBar(
//                                         context,
//                                         'Profile update successfully!',
//                                         Colors.green,
//                                       );
//                                     } else {
//                                       showTopSnackBar(
//                                         context,
//                                         'Failed to update profile. Please try again.',
//                                         Colors.red,
//                                       );
//                                     }
//                                   },
//                                   colorbg: AppColors.secondary,
//                                   colortext: AppColors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         // top: 10.h,
//                         top: -80.0.h,
//                         left: 110.0.w,
//                         child: Stack(
//                           clipBehavior: Clip.none,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 profileProvider.pickImage(ImageSource.gallery);
//                               },
//                               child: profileProvider.isFetchingImage ||
//                                       profileProvider.isUploading
//                                   ? Shimmer.fromColors(
//                                       baseColor: Colors.grey[300]!,
//                                       highlightColor: Colors.grey[100]!,
//                                       child: CircleAvatar(
//                                         radius: 60.0.r,
//                                         backgroundColor: Colors.grey[300],
//                                       ),
//                                     )
//                                   : CircleAvatar(
//                                       radius: 60.0.r,
//                                       backgroundImage:
//                                           profileProvider.pickedImage != null
//                                               ? FileImage(
//                                                   profileProvider.pickedImage!)
//                                               : profileProvider
//                                                       .imageUrl.isNotEmpty
//                                                   ? NetworkImage(
//                                                       profileProvider.imageUrl)
//                                                   : null,
//                                       backgroundColor: Colors.transparent,
//                                       child: profileProvider.imageUrl.isEmpty &&
//                                               profileProvider.pickedImage ==
//                                                   null
//                                           ? CircleAvatar(
//                                               radius: 60.0.r,
//                                               child: Icon(Icons.person,
//                                                   size: 60.0.r,
//                                                   color: AppColors.grey3),
//                                             )
//                                           : null,
//                                     ),
//                             ),
//                             Positioned(
//                               // top: 95.0.h,
//                               // left: 210.0.w,
//                               top: 90.0.h,
//                               left: 78.0.w,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   profileProvider
//                                       .pickImage(ImageSource.gallery);
//                                 },
//                                 child: Container(
//                                   height: 27.0.h,
//                                   width: 27.0.w,
//                                   decoration: BoxDecoration(
//                                     color: AppColors.white,
//                                     borderRadius: BorderRadius.circular(10.0.r),
//                                   ),
//                                   child: Icon(
//                                     Icons.edit_note,
//                                     color: AppColors.secondary,
//                                     size: 18.0.sp,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomNavigationBar: userChoice == 'Track'
//             ? const CustomBottomBar()
//             : const TrackingBottomBar(),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/provider/provider.dart';
import 'package:gentech/utils/custom_bottom_bar.dart';
import 'package:gentech/utils/reused_button.dart';
import 'package:gentech/utils/reused_text_field.dart';
import 'package:gentech/view/To%20Be%20Tracked/home.dart';
import 'package:gentech/view/Tracking/home_tracking.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../provider/user_choice_provider.dart';
import '../../utils/snackbar.dart';
import '../Tracking/tracking_bottom_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? pickedImage;
  bool isUploading = false;
  bool isFetchingImage = false;

// Function to pick an image
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final userChoiceProvider = Provider.of<UserChoiceProvider>(context);
    final userChoice = userChoiceProvider.userChoice;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.sccafold,
        appBar: AppBar(
          backgroundColor: AppColors.sccafold,
          leading: InkWell(
            onTap: () {
              userChoice == 'Track'
                  ? Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Home()))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeTracking()));
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.primary,
            ),
          ),
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: 24.0.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                // top: .0,
                left: 15,
                right: 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(40.0.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.0.w,
                          ),
                          child: Column(
                            children: [
                              88.ph,
                              CustomTextField(
                                controller: profileProvider.usernameController,
                                text: 'Name',
                                toHide: false,
                                iconData: Icons.edit,
                              ),
                              // 24.ph,
                              // CustomTextField(
                              //   controller: profileProvider.emailController,
                              //   text: 'Email',
                              //   toHide: false,
                              //   iconData: Icons.edit,
                              // ),
                              // 24.ph,
                              // CustomTextField(
                              //   controller: profileProvider.passwordController,
                              //   text: '*****',
                              //   toHide: true,
                              //   iconData: Icons.edit,
                              // ),
                              24.ph,
                              CustomTextField(
                                controller:
                                    profileProvider.phonenumberController,
                                text: 'Phone Number',
                                toHide: false,
                                iconData: Icons.edit,
                              ),
                              24.ph,
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 20,
                                ),
                                child: ReusedButton(
                                  text: 'Update Profile',
                                  onPressed: () async {
                                    bool success = await profileProvider
                                        .updateUserData(context, pickedImage);
                                    if (success) {
                                      showTopSnackBar(
                                        context,
                                        'Profile updated successfully!',
                                        Colors.green,
                                      );
                                    } else {
                                      showTopSnackBar(
                                        context,
                                        'Failed to update profile.',
                                        Colors.red,
                                      );
                                    }
                                  },
                                  colorbg: AppColors.secondary,
                                  colortext: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: -60.0.h,
                        left: 110.0.w,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // GestureDetector(
                            //   onTap: () {
                            //     pickImage(ImageSource.gallery);
                            //   },
                            //   child: profileProvider.isFetchingImage ||
                            //           profileProvider.isUploading
                            //       ? Shimmer.fromColors(
                            //           baseColor: Colors.grey[300]!,
                            //           highlightColor: Colors.grey[100]!,
                            //           child: CircleAvatar(
                            //             radius: 60.0.r,
                            //             backgroundColor: Colors.grey[300],
                            //           ),
                            //         )
                            //       : CircleAvatar(
                            //           radius: 60.0.r,
                            //           backgroundImage:
                            //               profileProvider.pickedImage != null
                            //                   ? FileImage(
                            //                       profileProvider.pickedImage!)
                            //                   : profileProvider
                            //                           .imageUrl.isNotEmpty
                            //                       ? NetworkImage(
                            //                           profileProvider.imageUrl)
                            //                       : null,
                            //           backgroundColor: Colors.transparent,
                            //           child: profileProvider.imageUrl.isEmpty &&
                            //                   profileProvider.pickedImage ==
                            //                       null
                            //               ? CircleAvatar(
                            //                   radius: 60.0.r,
                            //                   child: Icon(Icons.person,
                            //                       size: 60.0.r,
                            //                       color: AppColors.grey3),
                            //                 )
                            //               : null,
                            //         ),
                            // ),
                            GestureDetector(
                              onTap: () {
                                pickImage(ImageSource.gallery);
                              },
                              child: isFetchingImage || isUploading
                                  ? Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[100]!,
                                      child: CircleAvatar(
                                        radius: 60.0.r,
                                        backgroundColor: Colors.grey[300],
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 60.0.r,
                                      backgroundImage: pickedImage != null
                                          ? FileImage(
                                              pickedImage!) // Show locally picked image
                                          : profileProvider.imageUrl.isNotEmpty
                                              ? NetworkImage(profileProvider
                                                  .imageUrl) // Show image from provider
                                              : null, // No image if URL is empty
                                      backgroundColor: Colors.transparent,
                                      child: pickedImage == null &&
                                              profileProvider.imageUrl.isEmpty
                                          ? CircleAvatar(
                                              radius: 60.0.r,
                                              child: Icon(
                                                Icons.person,
                                                size: 60.0.r,
                                                color: AppColors.grey3,
                                              ),
                                            )
                                          : null,
                                    ),
                            ),
                            Positioned(
                              top: 85.0.h,
                              left: 75.0.w,
                              child: GestureDetector(
                                onTap: () {
                                  pickImage(ImageSource.gallery);
                                },
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: userChoice == 'Track'
            ? const CustomBottomBar()
            : const TrackingBottomBar(),
      ),
    );
  }
}
