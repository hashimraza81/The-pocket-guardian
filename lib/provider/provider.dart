import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  String imageUrl = '';
  String userId = '';
  bool isUploading = false;
  bool isFetchingImage = true;
  File? pickedImage;

  ProfileProvider() {
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        userId = user.uid;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userChoice = prefs.getString('userChoice') ?? 'Track';

        String collectionPath =
            userChoice == 'Track' ? 'trackUsers' : 'trackingUsers';

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(collectionPath)
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          usernameController.text = userDoc['name'] ?? '';
          emailController.text = userDoc['email'] ?? '';
          phonenumberController.text = userDoc['phonenumber'] ?? '';
          imageUrl = userDoc['imageUrl'] ?? '';
        }

        isFetchingImage = false;
        notifyListeners();
      }
    } catch (e) {
      isFetchingImage = false;
      notifyListeners();
      print('Error fetching user data: $e');
    }
  }

  Future<bool> updateUserData(BuildContext context, var file) async {
    _showLoadingIndicator(context);
    if (userId.isNotEmpty) {
      User? user = FirebaseAuth.instance.currentUser;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userChoice = prefs.getString('userChoice') ?? 'Track';

      if (user != null) {
        try {
          // // Update email if needed
          // if (emailController.text != user.email) {
          //   await user.updateEmail(emailController.text);
          //   await user.sendEmailVerification();
          // }

          // // Update password if it's not empty
          // if (passwordController.text.isNotEmpty) {
          //   await user.updatePassword(passwordController.text);
          // }

          String newImageUrl = imageUrl;
          if (file != null) {
            isUploading = true;
            notifyListeners();

            // Only attempt to delete the previous image if the imageUrl is valid and not empty
            if (imageUrl.isNotEmpty) {
              try {
                await FirebaseStorage.instance.refFromURL(imageUrl).delete();
              } catch (e) {
                print('Error deleting previous image: $e');
              }
            }

            // Upload new image to Firebase Storage
            Reference storageRef = FirebaseStorage.instance
                .ref()
                .child('images')
                .child('$userId.png');
            await storageRef.putFile(file!);
            newImageUrl = await storageRef.getDownloadURL();

            isUploading = false;
            notifyListeners();
          }

          // Update the user data in Firestore
          await FirebaseFirestore.instance
              .collection(
                  userChoice == 'Track' ? 'trackUsers' : 'trackingUsers')
              .doc(userId)
              .update({
            'name': usernameController.text,
            'email': emailController.text,
            'phonenumber': phonenumberController.text,
            'imageUrl': newImageUrl,
          });

          Navigator.pop(context);

          notifyListeners();
          return true; // Return true on success
        } catch (e) {
          print('Error updating user data: $e');
          return false; // Return false if an error occurs
        }
      }
    }
    return false;
  }

  void _showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<void> clearUserProfileCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Notify listeners about the state change
  }
}

// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:gentech/utils/snackbar.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileProvider with ChangeNotifier {
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController phonenumberController = TextEditingController();
//   String imageUrl = '';
//   String userId = '';
//   bool isUploading = false;
//   bool isFetchingImage = true;
//   File? pickedImage;
//   String? _errorMessage;

//   ProfileProvider() {
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         userId = user.uid;

//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         String userChoice = prefs.getString('userChoice') ?? 'Track';

//         String collectionPath =
//             userChoice == 'Track' ? 'trackUsers' : 'trackingUsers';

//         DocumentSnapshot userDoc = await FirebaseFirestore.instance
//             .collection(collectionPath)
//             .doc(user.uid)
//             .get();

//         if (userDoc.exists) {
//           usernameController.text = userDoc['name'] ?? '';
//           emailController.text = userDoc['email'] ?? '';
//           phonenumberController.text = userDoc['phonenumber'] ?? '';
//           imageUrl = userDoc['imageUrl'] ?? '';
//         }

//         isFetchingImage = false;
//         notifyListeners();
//       }
//     } catch (e) {
//       isFetchingImage = false;
//       notifyListeners();
//       print('Error fetching user data: $e');
//     }
//   }

//   Future<bool> updateUserData(BuildContext context, var file) async {
//     _showLoadingIndicator(context);
//     if (userId.isNotEmpty) {
//       User? user = FirebaseAuth.instance.currentUser;
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String userChoice = prefs.getString('userChoice') ?? 'Track';

//       if (user != null) {
//         try {
//           // Reauthenticate before updating sensitive data
//           bool reauthenticated = await _reauthenticate(context);
//           if (!reauthenticated) {
//             return false;
//           }

//           // Update email in Firebase Authentication if needed
//           if (emailController.text != user.email) {
//             await _updateEmail(context);
//           }

//           // Update password in Firebase Authentication if not empty
//           if (passwordController.text.isNotEmpty) {
//             await _updatePassword(context);
//           }

//           // Handle profile image update
//           String newImageUrl = imageUrl;
//           if (file != null) {
//             isUploading = true;
//             notifyListeners();

//             if (imageUrl.isNotEmpty) {
//               try {
//                 await FirebaseStorage.instance.refFromURL(imageUrl).delete();
//               } catch (e) {
//                 print('Error deleting previous image: $e');
//               }
//             }

//             Reference storageRef = FirebaseStorage.instance
//                 .ref()
//                 .child('images')
//                 .child('$userId.png');
//             await storageRef.putFile(file!);
//             newImageUrl = await storageRef.getDownloadURL();

//             isUploading = false;
//             notifyListeners();
//           }

//           // Update Firestore
//           await FirebaseFirestore.instance
//               .collection(
//                   userChoice == 'Track' ? 'trackUsers' : 'trackingUsers')
//               .doc(userId)
//               .update({
//             'name': usernameController.text,
//             'email': emailController.text,
//             'phonenumber': phonenumberController.text,
//             'imageUrl': newImageUrl,
//           });

//           Navigator.pop(context);

//           notifyListeners();
//           return true;
//         } catch (e) {
//           print('Error updating user data: $e');

//           showTopSnackBar(context, 'Error: ${e.toString()}', Colors.red);
//           // ScaffoldMessenger.of(context).showSnackBar(
//           //   SnackBar(content: Text('Error: ${e.toString()}')),
//           // );
//           return false;
//         }
//       }
//     }
//     return false;
//   }

//   Future<void> _updateEmail(BuildContext context) async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null && user.emailVerified) {
//         await user.verifyBeforeUpdateEmail(emailController.text.trim());
//         showTopSnackBar(
//             context,
//             'Verification email sent to new address. Please verify to complete the update.',
//             Colors.green);
//         // ScaffoldMessenger.of(context).showSnackBar(
//         //   const SnackBar(
//         //       content: Text(
//         //           'Verification email sent to new address. Please verify to complete the update.')),
//         // );
//       } else {
//         showTopSnackBar(context,
//             'Please verify your current email before updating.', Colors.green);

//         notifyListeners();
//       }
//     } on FirebaseAuthException catch (e) {
//       _errorMessage = e.message;
//       notifyListeners();
//     }
//   }

//   // Future<void> _updateEmail(BuildContext context) async {
//   //   try {
//   //     User? user = FirebaseAuth.instance.currentUser;
//   //     if (user != null) {
//   //       await user.updateEmail(
//   //           emailController.text.trim()); // Directly update the email
//   //       showTopSnackBar(context, 'Email updated successfully.', Colors.green);
//   //     } else {
//   //       showTopSnackBar(context, 'User is not logged in.', Colors.red);
//   //     }
//   //   } on FirebaseAuthException catch (e) {
//   //     _errorMessage = e.message;
//   //     showTopSnackBar(
//   //         context, _errorMessage ?? 'An error occurred', Colors.red);
//   //   }
//   // }

//   Future<void> _updatePassword(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.currentUser
//           ?.updatePassword(passwordController.text);
//       // ScaffoldMessenger.of(context).showSnackBar(
//       //   const SnackBar(content: Text('Password updated successfully')),
//       // );
//       showTopSnackBar(context, 'Password updated successfully', Colors.green);
//     } on FirebaseAuthException catch (e) {
//       _errorMessage = e.message;
//       notifyListeners();
//     }
//   }

//   Future<bool> _reauthenticate(BuildContext context) async {
//     final passwordController = TextEditingController();
//     bool? result = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         title: const Text('Reauthentication Required'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('Please enter your current password to continue.'),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: 'Current Password'),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               try {
//                 final credential = EmailAuthProvider.credential(
//                   email: FirebaseAuth.instance.currentUser!.email!,
//                   password: passwordController.text,
//                 );
//                 await FirebaseAuth.instance.currentUser
//                     ?.reauthenticateWithCredential(credential);
//                 Navigator.of(context).pop(true);
//               } on FirebaseAuthException catch (e) {
//                 Navigator.of(context).pop(false);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('${e.code}: ${e.message}')),
//                 );
//               }
//             },
//             child: const Text('Confirm'),
//           ),
//         ],
//       ),
//     );
//     return result ?? false;
//   }

//   void _showLoadingIndicator(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       },
//     );
//   }

//   Future<void> clearUserProfileCache() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
// }
