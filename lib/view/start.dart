// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gentech/const/app_colors.dart';
// import 'package:gentech/const/app_images.dart';
// import 'package:gentech/routes/routes_names.dart';
// import 'package:gentech/utils/bottom_round_clipper.dart';
// import 'package:url_launcher/url_launcher.dart';

// class Start extends StatefulWidget {
//   const Start({super.key});

//   @override
//   State<Start> createState() => _StartState();
// }

// class _StartState extends State<Start> {
//   late FirebaseMessaging _firebaseMessaging;

//   @override
//   void initState() {
//     super.initState();
//     _initializeFirebaseMessaging();
//     // Schedule navigation to the next screen after a 10 second delay
//     Future.delayed(const Duration(seconds: 10), () {
//       Navigator.pushNamed(context, RoutesName.splashscreen);
//     });
//   }

//   void _initializeFirebaseMessaging() async {
//     await Firebase.initializeApp();
//     _firebaseMessaging = FirebaseMessaging.instance;

//     // Request permission for iOS
//     NotificationSettings settings =
//         await _firebaseMessaging.requestPermission();

//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }

//     // Listen for token refresh
//     _firebaseMessaging.onTokenRefresh.listen((newToken) {
//       print("New Token: $newToken");
//       // Save the new token in your backend
//     });

//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Received message in foreground: ${message.messageId}');
//       _showMessage(message);
//     });

//     // Handle background messages
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('Message clicked!');
//       _handleMessage(message);
//     });

//     // Handle initial message when the app is opened from a terminated state
//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) {
//       if (message != null) {
//         _handleMessage(message);
//       }
//     });
//   }

//   void _handleMessage(RemoteMessage message) {
//     final String? mapsUrl = message.data['mapsUrl'];

//     if (mapsUrl != null) {
//       _launchURL(mapsUrl);
//     }
//   }

//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url); // Correctly create a Uri object

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }

//   void _showMessage(RemoteMessage message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(message.notification?.title ?? "Notification"),
//         content: Text(message.notification?.body ?? "No message body"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("OK"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: AppColors.sccafold,
//         body: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             children: [
//               SizedBox(
//                 width: 524.w,
//                 height: 484.h,
//                 child: ClipPath(
//                   clipper: BottomRoundClipper(),
//                   child: Image.asset(
//                     AppImages.splash,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 76.h),
//               Image.asset(AppImages.logo),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/bottom_round_clipper.dart';
import 'package:url_launcher/url_launcher.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  late FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
    // Schedule navigation to the next screen after a 10 second delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushNamed(context, RoutesName.splashscreen);
    });
  }

  void _initializeFirebaseMessaging() async {
    await Firebase.initializeApp();
    if (!mounted) return; // Check if the state is still mounted

    _firebaseMessaging = FirebaseMessaging.instance;

    // Request permission for iOS
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      if (!mounted) return; // Check if the state is still mounted
      print("New Token: $newToken");
      // Save the new token in your backend
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (!mounted) return; // Check if the state is still mounted
      print('Received message in foreground: ${message.messageId}');
      _showMessage(message);
    });

    // Handle background and terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (!mounted) return; // Check if the state is still mounted
      print('Message clicked!');
      _handleMessage(message);
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (!mounted) return; // Check if the state is still mounted
      if (message != null) {
        _handleMessage(message);
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
    if (!mounted) return;

    final String? mapsUrl = message.data['mapsUrl'];
    final String? route = message.data['route'];

    // if (mapsUrl != null) {
    //   _launchURL(mapsUrl);
    // } else
    if (route != null && route == RoutesName.notification) {
      Navigator.pushNamed(context, RoutesName.notification);
    } else if (route != null) {
      Navigator.pushNamed(context, route);
    } else {
      // Navigate to a default screen if no route is specified
      Navigator.pushNamed(context, RoutesName.notification);
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _showMessage(RemoteMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.notification?.title ?? "Notification"),
        content: Text(message.notification?.body ?? "No message body"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, RoutesName.notification);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

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
                    AppImages.splash,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 76.h),
              Image.asset(AppImages.logo),
            ],
          ),
        ),
      ),
    );
  }
}
