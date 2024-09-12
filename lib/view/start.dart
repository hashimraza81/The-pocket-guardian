import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/const/app_images.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/bottom_round_clipper.dart';
import 'package:permission_handler/permission_handler.dart';

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
//     _checkPermissions();
//     // Schedule navigation to the next screen after a 10 second delay
//     Future.delayed(const Duration(seconds: 5), () {
//       Navigator.pushNamed(context, RoutesName.signin);
//     });
//   }

//   Future<void> _checkPermissions() async {
//     // Check location permission
//     if (await Permission.location.isDenied) {
//       await _requestLocationPermission();
//     }

//     // Check notification permission
//     if (await Permission.notification.isDenied) {
//       await _requestNotificationPermission();
//     }

//     // Check contacts permission
//     if (await Permission.contacts.isDenied) {
//       await _requestContactsPermission();
//     }
//   }

//   Future<void> _requestLocationPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status.isDenied) {
//       // _showPermissionsDeniedDialog();
//     }
//   }

//   Future<void> _requestNotificationPermission() async {
//     PermissionStatus status = await Permission.notification.request();
//     if (status.isDenied) {
//       // _showPermissionsDeniedDialog();
//     }
//   }

//   Future<void> _requestContactsPermission() async {
//     PermissionStatus status = await Permission.contacts.request();
//     if (status.isDenied) {
//       // _showPermissionsDeniedDialog();
//     }
//   }

//   void _initializeFirebaseMessaging() async {
//     await Firebase.initializeApp();
//     if (!mounted) return; // Check if the state is still mounted

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
//       if (!mounted) return; // Check if the state is still mounted
//       print("New Token: $newToken");
//       // Save the new token in your backend
//     });

//     // Handle foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (!mounted) return; // Check if the state is still mounted
//       print('Received message in foreground: ${message.messageId}');
//       _showMessage(message);
//     });

//     // Handle background and terminated messages
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if (!mounted) return; // Check if the state is still mounted
//       print('Message clicked!');
//       _handleMessage(message);
//     });

//     FirebaseMessaging.instance
//         .getInitialMessage()
//         .then((RemoteMessage? message) {
//       if (!mounted) return; // Check if the state is still mounted
//       if (message != null) {
//         _handleMessage(message);
//       }
//     });
//   }

//   void _handleMessage(RemoteMessage message) {
//     // if (!mounted) return;

//     // final String? mapsUrl = message.data['mapsUrl'];
//     // final String? route = message.data['route'];

//     // if (route != null && route == RoutesName.notification) {
//     //   Navigator.pushNamed(context, RoutesName.notification);
//     // } else if (route != null) {
//     //   Navigator.pushNamed(context, route);
//     // } else {
//     //   // Navigate to a default screen if no route is specified
//     //   Navigator.pushNamed(context, RoutesName.notification);
//     // }
//   }

//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);

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
//             onPressed: () {
//               Navigator.pushNamed(context, RoutesName.notification);
//             },
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
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    // Request multiple permissions at once
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.notification,
      Permission.contacts,
    ].request();

    // Check if all required permissions are granted
    if (statuses.values.every((status) => status.isGranted)) {
      _initializeFirebaseMessaging();
      // Delay and navigate to the next screen after permissions are granted
      Future.delayed(const Duration(seconds: 5), () {
        Navigator.pushNamed(context, RoutesName.signin);
      });
    } else {
      // Handle denied permissions
      // _showPermissionsDeniedDialog();
    }
  }

  void _initializeFirebaseMessaging() async {
    await Firebase.initializeApp();
    if (!mounted) return; // Check if the state is still mounted

    _firebaseMessaging = FirebaseMessaging.instance;

    // Request notification permission for iOS devices
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

    final String? route = message.data['route'];
    if (route != null && route == RoutesName.notification) {
      Navigator.pushNamed(context, RoutesName.notification);
    } else if (route != null) {
      Navigator.pushNamed(context, route);
    } else {
      Navigator.pushNamed(context, RoutesName.notification);
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
