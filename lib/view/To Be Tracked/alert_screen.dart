// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gentech/const/app_colors.dart';
// import 'package:gentech/const/app_images.dart';
// import 'package:gentech/extension/sizebox_extension.dart';
// import 'package:gentech/utils/custom_text_widget.dart';
// import 'package:gentech/view/To%20Be%20Tracked/home.dart';
// import 'package:url_launcher/url_launcher.dart';

// import 'dart:async';
// import 'package:geolocator/geolocator.dart';
// import 'package:gentech/model/contact_model.dart';

// import '../../app notification/push_notification.dart';  // Import the Contact class

// class AlertScreen extends StatefulWidget {
//   const AlertScreen({super.key});

//   @override
//   State<AlertScreen> createState() => _AlertScreenState();
// }

// class _AlertScreenState extends State<AlertScreen> {
//   List<Contact> contacts = [];

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   fetchContacts();
//   // }

//   // Future<void> fetchContacts() async {
//   //   try {
//   //     User? user = FirebaseAuth.instance.currentUser;
//   //     if (user != null) {
//   //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//   //           .collection('trackUsers')
//   //           .doc(user.uid)
//   //           .get();
//   //       if (userDoc.exists) {
//   //         CollectionReference contactsRef =
//   //             userDoc.reference.collection('contacts');
//   //         QuerySnapshot contactsSnapshot = await contactsRef.get();
//   //         setState(() {
//   //           contacts = contactsSnapshot.docs
//   //               .map((doc) => Contact.fromFirestore(doc))
//   //               .toList();
//   //         });
//   //       }
//   //     }
//   //   } catch (e) {
//   //     print('Error fetching contacts: $e');
//   //   }
//   // }

//    Timer? _timer;
//   Position? _currentPosition;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//     _getCurrentLocation();
//   }

//   void _startTimer() {
//     _timer = Timer(Duration(seconds: 30), () {
//       _sendAlertToContacts();
//     });
//   }

//   Future<void> _getCurrentLocation() async {
//     _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//   }

//   Future<void> _sendAlertToContacts() async {
//     List<Contact> contacts = await fetchContacts();
//     User? user = FirebaseAuth.instance.currentUser;

//     if (_currentPosition != null && user != null) {
//       for (Contact contact in contacts) {
//         String? deviceToken = await getDeviceTokenFromContact(contact);
//         if (deviceToken != null) {
//           PushNotification.sendNotificationToSelectedRole(
//             deviceToken,
//             context,
//             user.uid,
//             contact.id,
//             _currentPosition!.latitude,
//             _currentPosition!.longitude,
//             'Emergency Alert',
//             'User is in a potential emergency situation.',
//           );
//         } else {
//           print('Device token not found for contact: ${contact.name}');
//         }
//       }
//     }
//   }

//   Future<List<Contact>> fetchContacts() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('trackUsers')
//           .doc(user.uid)
//           .get();
//       if (userDoc.exists) {
//         CollectionReference contactsRef = userDoc.reference.collection('contacts');
//         QuerySnapshot contactsSnapshot = await contactsRef.get();
//         return contactsSnapshot.docs.map((doc) => Contact.fromFirestore(doc)).toList();
//       }
//     }
//     return [];
//   }

//   Future<String?> getDeviceTokenFromContact(Contact contact) async {
//     try {
//       print('Reference: ${contact.reference}'); // Debugging log

//       // Fetch the user's document using the reference stored in the contact
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .doc(contact.reference) // 'reference' field in the Contact document
//           .get();

//       if (userDoc.exists) {
//         // Return the deviceToken field from the user's document
//         return userDoc.data() != null
//             ? (userDoc.data() as Map<String, dynamic>)['deviceToken'] as String?
//             : null;
//       } else {
//         print('User document does not exist');
//         return null;
//       }
//     } catch (error) {
//       print('Error fetching device token: $error');
//       return null;
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.red,
//         body: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     vertical: 25.0.h,
//                     horizontal: 16.0.w,
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       height: 44.0.h,
//                       width: 44.0.w,
//                       decoration: BoxDecoration(
//                         color: AppColors.white,
//                         borderRadius: BorderRadius.circular(
//                           10.0.r,
//                         ),
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back_ios,
//                         color: AppColors.secondary,
//                       ),
//                     ),
//                   ),
//                 ),
//                 55.0.ph,
//                 Center(
//                   child: Image.asset(AppImages.alert),
//                 ),
//                 20.0.ph,
//                 Center(
//                   child: CustomText(
//                     text: 'Alert',
//                     size: 36.0.sp,
//                     color: AppColors.white,
//                     fontWeight: FontWeight.w400,
//                     familyFont: 'Montserrat',
//                   ),
//                 ),
//                 30.0.ph,
//                 Center(
//                   child: CustomText(
//                     text: 'An alert has been sent to\n          your contacts',
//                     size: 16.0.sp,
//                     color: AppColors.white,
//                     fontWeight: FontWeight.w500,
//                     familyFont: 'Montserrat',
//                   ),
//                 ),
//                 48.0.ph,
//                 Center(
//                   child: CircleAvatar(
//                     backgroundColor: AppColors.white,
//                     radius: 60.0.r,
//                     child: InkWell(
//                       onTap: (){
//                          _timer?.cancel();
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (_) => Home()),
//               );
//                       },
//                       child: CustomText(
//                         text: "I'm Safe",
//                         size: 20.0.sp,
//                         color: AppColors.red,
//                         fontWeight: FontWeight.w600,
//                         familyFont: 'Montserrat',
//                       ),
//                     ),
//                   ),
//                 ),
//                 90.0.ph,
//                 contacts.isEmpty
//                     ? Center(
//                         child: CustomText(
//                           text: 'No contacts available',
//                           size: 16.0.sp,
//                           color: AppColors.white,
//                           fontWeight: FontWeight.w500,
//                           familyFont: 'Montserrat',
//                         ),
//                       )
//                     : Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16.0.w,
//                         ),
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: contacts.length,
//                           itemBuilder: (context, index) {
//                             final contact = contacts[index];
//                             return Padding(
//                               padding: EdgeInsets.symmetric(vertical: 8.0.h),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Button(
//                                     text: 'Message',
//                                     onPressed: () async {
//                                       await launchUrl(
//                                         Uri(
//                                           scheme: 'sms',
//                                           path: contact.phoneNumber,
//                                         ),
//                                       );
//                                     },
//                                     colorbg: Colors.transparent,
//                                     bordercolor: AppColors.white,
//                                     colortext: AppColors.white,
//                                     image: AppImages.msg,
//                                   ),
//                                   Button(
//                                     text: 'Call',
//                                     onPressed: () async {
//                                       await launchUrl(
//                                         Uri(
//                                           scheme: 'tel',
//                                           path: contact.phoneNumber,
//                                         ),
//                                       );
//                                     },
//                                     colorbg: Colors.transparent,
//                                     bordercolor: AppColors.white,
//                                     colortext: AppColors.white,
//                                     image: AppImages.call,
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Button extends StatelessWidget {
//   final String text;
//   final String image;
//   final VoidCallback onPressed;
//   final Color? colorbg;
//   final Color? colortext;
//   final Color? bordercolor;

//   const Button({
//     super.key,
//     required this.text,
//     required this.image,
//     required this.onPressed,
//     this.colorbg,
//     this.colortext,
//     this.bordercolor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: colorbg,
//         borderRadius: BorderRadius.circular(128.r),
//         border: Border.all(
//           width: 1,
//           color: bordercolor ?? Colors.transparent,
//         ),
//       ),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(128.r),
//           ),
//           minimumSize: Size(170.w, 50.h),
//         ),
//         onPressed: onPressed,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(image),
//             5.0.pw,
//             Text(
//               text,
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 color: colortext,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Montserrat',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Contact {
//   final String id;
//   final String name;
//   final String phoneNumber;
//   final String imageUrl;

//   Contact({
//     required this.id,
//     required this.name,
//     required this.phoneNumber,
//     required this.imageUrl,
//   });

//   factory Contact.fromFirestore(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     return Contact(
//       id: doc.id,
//       name: data['name'] ?? '',
//       phoneNumber: data['phonenumber'] ?? '',
//       imageUrl: data['imageUrl'] ?? '',
//     );
//   }
// }

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gentech/app notification/push_notification.dart'; // Correct import
// import 'package:gentech/const/app_colors.dart';
// import 'package:gentech/const/app_images.dart';
// import 'package:gentech/extension/sizebox_extension.dart';
// import 'package:gentech/model/contact_model.dart'; // Correct import
// import 'package:gentech/utils/custom_text_widget.dart';
// import 'package:gentech/view/To%20Be%20Tracked/home.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AlertScreen extends StatefulWidget {
//   const AlertScreen({super.key});

//   @override
//   State<AlertScreen> createState() => _AlertScreenState();
// }

// class _AlertScreenState extends State<AlertScreen> {
//   Timer? _timer;
//   Position? _currentPosition;
//   List<Contact> contacts = [];

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//     _getCurrentLocation();
//     fetchContacts();
//   }

//   void _startTimer() {
//     _timer = Timer(const Duration(seconds: 30), () {
//       _sendAlertToContacts();
//     });
//   }

//   Future<void> _getCurrentLocation() async {
//     _currentPosition = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }

//   Future<void> _sendAlertToContacts() async {
//     User? user = FirebaseAuth.instance.currentUser;

//     if (_currentPosition != null && user != null) {
//       for (Contact contact in contacts) {
//         String? deviceToken = await getDeviceTokenFromContact(contact);
//         if (deviceToken != null) {
//           PushNotification.sendNotificationToSelectedRole(
//             deviceToken,
//             context,
//             user.uid,
//             contact.id,
//             _currentPosition!.latitude,
//             _currentPosition!.longitude,
//             'Emergency Alert',
//             'User is in a potential emergency situation.',
//           );
//         } else {
//           print('Device token not found for contact: ${contact.name}');
//         }
//       }
//     }
//   }

//   Future<void> fetchContacts() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('trackUsers')
//           .doc(user.uid)
//           .get();
//       if (userDoc.exists) {
//         CollectionReference contactsRef =
//             userDoc.reference.collection('contacts');
//         QuerySnapshot contactsSnapshot = await contactsRef.get();
//         setState(() {
//           contacts = contactsSnapshot.docs
//               .map((doc) => Contact.fromFirestore(doc))
//               .toList();
//         });
//       }
//     }
//   }

//   Future<String?> getDeviceTokenFromContact(Contact contact) async {
//     try {
//       print('Reference: ${contact.reference}'); // Debugging log

//       // Fetch the user's document using the reference stored in the contact
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .doc(contact.reference) // 'reference' field in the Contact document
//           .get();

//       if (userDoc.exists) {
//         // Return the deviceToken field from the user's document
//         return userDoc.data() != null
//             ? (userDoc.data() as Map<String, dynamic>)['deviceToken'] as String?
//             : null;
//       } else {
//         print('User document does not exist');
//         return null;
//       }
//     } catch (error) {
//       print('Error fetching device token: $error');
//       return null;
//     }
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.red,
//         body: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(
//                     vertical: 25.0.h,
//                     horizontal: 16.0.w,
//                   ),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Container(
//                       height: 44.0.h,
//                       width: 44.0.w,
//                       decoration: BoxDecoration(
//                         color: AppColors.white,
//                         borderRadius: BorderRadius.circular(
//                           10.0.r,
//                         ),
//                       ),
//                       child: const Icon(
//                         Icons.arrow_back_ios,
//                         color: AppColors.secondary,
//                       ),
//                     ),
//                   ),
//                 ),
//                 55.0.ph,
//                 Center(
//                   child: Image.asset(AppImages.alert),
//                 ),
//                 20.0.ph,
//                 Center(
//                   child: CustomText(
//                     text: 'Alert',
//                     size: 36.0.sp,
//                     color: AppColors.white,
//                     fontWeight: FontWeight.w400,
//                     familyFont: 'Montserrat',
//                   ),
//                 ),
//                 30.0.ph,
//                 Center(
//                   child: CustomText(
//                     text: 'An alert has been sent to\n          your contacts',
//                     size: 16.0.sp,
//                     color: AppColors.white,
//                     fontWeight: FontWeight.w500,
//                     familyFont: 'Montserrat',
//                   ),
//                 ),
//                 48.0.ph,
//                 Center(
//                   child: CircleAvatar(
//                     backgroundColor: AppColors.white,
//                     radius: 60.0.r,
//                     child: InkWell(
//                       onTap: () {
//                         _timer?.cancel();
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(builder: (_) => const Home()),
//                         );
//                       },
//                       child: CustomText(
//                         text: "I'm Safe",
//                         size: 20.0.sp,
//                         color: AppColors.red,
//                         fontWeight: FontWeight.w600,
//                         familyFont: 'Montserrat',
//                       ),
//                     ),
//                   ),
//                 ),
//                 90.0.ph,
//                 contacts.isEmpty
//                     ? Center(
//                         child: CustomText(
//                           text: 'No contacts available',
//                           size: 16.0.sp,
//                           color: AppColors.white,
//                           fontWeight: FontWeight.w500,
//                           familyFont: 'Montserrat',
//                         ),
//                       )
//                     : Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 16.0.w,
//                         ),
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: contacts.length,
//                           itemBuilder: (context, index) {
//                             final contact = contacts[index];
//                             return Padding(
//                               padding: EdgeInsets.symmetric(vertical: 8.0.h),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Button(
//                                     text: 'Message',
//                                     onPressed: () async {
//                                       await launchUrl(
//                                         Uri(
//                                           scheme: 'sms',
//                                           path: contact.phoneNumber,
//                                         ),
//                                       );
//                                     },
//                                     colorbg: Colors.transparent,
//                                     bordercolor: AppColors.white,
//                                     colortext: AppColors.white,
//                                     image: AppImages.msg,
//                                   ),
//                                   Button(
//                                     text: 'Call',
//                                     onPressed: () async {
//                                       await launchUrl(
//                                         Uri(
//                                           scheme: 'tel',
//                                           path: contact.phoneNumber,
//                                         ),
//                                       );
//                                     },
//                                     colorbg: Colors.transparent,
//                                     bordercolor: AppColors.white,
//                                     colortext: AppColors.white,
//                                     image: AppImages.call,
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class Button extends StatelessWidget {
//   final String text;
//   final String image;
//   final VoidCallback onPressed;
//   final Color? colorbg;
//   final Color? colortext;
//   final Color? bordercolor;

//   const Button({
//     super.key,
//     required this.text,
//     required this.image,
//     required this.onPressed,
//     this.colorbg,
//     this.colortext,
//     this.bordercolor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: colorbg,
//         borderRadius: BorderRadius.circular(128.r),
//         border: Border.all(
//           width: 1,
//           color: bordercolor ?? Colors.transparent,
//         ),
//       ),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(128.r),
//           ),
//           minimumSize: Size(170.w, 50.h),
//         ),
//         onPressed: onPressed,
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(image),
//             5.0.pw,
//             Text(
//               text,
//               style: TextStyle(
//                 fontSize: 16.sp,
//                 color: colortext,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Montserrat',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/extension/sizebox_extension.dart';
import 'package:gentech/model/contact_model.dart';
import 'package:gentech/utils/contact_listview.dart';
import 'package:gentech/utils/custom_text_widget.dart';
import 'package:gentech/view/To%20Be%20Tracked/home.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app notification/push_notification.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  Timer? _timer;
  Position? _currentPosition;
  List<Contact> contacts = [];
  bool _alertSent = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _getCurrentLocation();
    fetchContacts();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 30), () {
      _sendAlertToContacts();
    });
  }

  Future<void> _getCurrentLocation() async {
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _sendAlertToContacts() async {
    if (_alertSent) return; // Prevent multiple notifications

    _alertSent = true;
    User? user = FirebaseAuth.instance.currentUser;

    if (_currentPosition != null && user != null) {
      for (Contact contact in contacts) {
        String? deviceToken = await getDeviceTokenFromContact(contact);
        if (deviceToken != null) {
          PushNotification.sendNotificationToSelectedRole(
            deviceToken,
            context,
            user.uid,
            contact.uid,
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            'Emergency Alert',
            'User is in a potential emergency situation.',
          );
        } else {
          print('Device token not found for contact: ${contact.name}');
        }
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  Future<void> fetchContacts() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('trackUsers')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        CollectionReference contactsRef =
            userDoc.reference.collection('contacts');
        QuerySnapshot contactsSnapshot = await contactsRef.get();
        setState(() {
          contacts = contactsSnapshot.docs
              .map((doc) => Contact.fromFirestore(doc))
              .toList();
        });
      }
    }
  }

  Future<String?> getDeviceTokenFromContact(Contact contact) async {
    try {
      print('Reference: ${contact.reference}'); // Debugging log

      // Fetch the user's document using the reference stored in the contact
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .doc(contact.reference) // 'reference' field in the Contact document
          .get();

      if (userDoc.exists) {
        // Return the deviceToken field from the user's document
        return userDoc.data() != null
            ? (userDoc.data() as Map<String, dynamic>)['deviceToken'] as String?
            : null;
      } else {
        print('User document does not exist');
        return null;
      }
    } catch (error) {
      print('Error fetching device token: $error');
      return null;
    }
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          onContactSelected: (contact) {
            // Handle contact selection here
            Navigator.pop(context);
            _showContactOptionsDialog(contact);
          },
        );
      },
    );
  }

  void _showContactOptionsDialog(Contact contact) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Contact Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.call),
                title: const Text('Call'),
                onTap: () {
                  launchUrl(
                    Uri(
                      scheme: 'tel',
                      path: contact.phoneNumber,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Message'),
                onTap: () {
                  launchUrl(
                    Uri(
                      scheme: 'sms',
                      path: contact.phoneNumber,
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.red,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 25.0.h,
                    horizontal: 16.0.w,
                  ),
                  child: InkWell(
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
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ),
                55.0.ph,
                Center(
                  child: Image.asset(AppImages.alert),
                ),
                20.0.ph,
                Center(
                  child: CustomText(
                    text: 'Alert',
                    size: 36.0.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                    familyFont: 'Montserrat',
                  ),
                ),
                30.0.ph,
                Center(
                  child: CustomText(
                    text: 'An alert has been sent to\n          your contacts',
                    size: 16.0.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                    familyFont: 'Montserrat',
                  ),
                ),
                48.0.ph,
                Center(
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    radius: 60.0.r,
                    child: InkWell(
                      onTap: () {
                        _timer?.cancel();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Home()),
                        );
                      },
                      child: CustomText(
                        text: "I'm Safe",
                        size: 20.0.sp,
                        color: AppColors.red,
                        fontWeight: FontWeight.w600,
                        familyFont: 'Montserrat',
                      ),
                    ),
                  ),
                ),
                90.0.ph,
                contacts.isEmpty
                    ? Center(
                        child: CustomText(
                          text: 'No contacts available',
                          size: 16.0.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          familyFont: 'Montserrat',
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Button(
                              text: 'Message',
                              onPressed: () async {
                                _showContactDialog();
                              },
                              colorbg: Colors.transparent,
                              bordercolor: AppColors.white,
                              colortext: AppColors.white,
                              image: AppImages.msg,
                            ),
                            Button(
                              text: 'Call',
                              onPressed: () {
                                _showContactDialog();
                              },
                              colorbg: Colors.transparent,
                              bordercolor: AppColors.white,
                              colortext: AppColors.white,
                              image: AppImages.call,
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final void Function(Contact contact) onContactSelected;

  const CustomDialog({super.key, required this.onContactSelected});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0.r),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 16.0.h,
          horizontal: 10.0.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Contacts',
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Montserrat',
                  color: AppColors.primary,
                ),
              ),
            ),
            16.0.ph,
            ContactListview(onContactSelected: onContactSelected),
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String text;
  final String image;
  final VoidCallback onPressed;
  final Color? colorbg;
  final Color? colortext;
  final Color? bordercolor;

  const Button({
    super.key,
    required this.text,
    required this.image,
    required this.onPressed,
    this.colorbg,
    this.colortext,
    this.bordercolor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorbg,
        borderRadius: BorderRadius.circular(128.r),
        border: Border.all(
          width: 1,
          color: bordercolor ?? Colors.transparent,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(128.r),
          ),
          minimumSize: Size(170.w, 50.h),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image),
            5.0.pw,
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: colortext,
                fontWeight: FontWeight.w500,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
