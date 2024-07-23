import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/firebase_options.dart';
import 'package:gentech/provider/location_Provider.dart';
import 'package:gentech/provider/marker_Provider.dart';
import 'package:gentech/provider/navigationProvider.dart';
import 'package:gentech/provider/option_provider.dart';
import 'package:gentech/provider/places_provider.dart';
import 'package:gentech/provider/profile_Provider.dart';
import 'package:gentech/provider/tracking_bottom_bar_Provider.dart';
import 'package:gentech/provider/userProvider.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/routes/routes.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => TrackingBottomBarProvider()),
        ChangeNotifierProvider(create: (_) => UserChoiceProvider()),
        ChangeNotifierProvider(create: (_) => OptionProvider()),
        ChangeNotifierProvider(create: (_) => MarkerProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => PlacesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 791),
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gentech',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.white,
        ),
        initialRoute: determineInitialRoute(context),
        onGenerateRoute: Routes.generateRoute,
        builder: (context, child) {
          return WillPopScope(
            onWillPop: () async {
              // Handle back button press here
              bool isOnHomePage =
                  ModalRoute.of(context)?.settings.name == RoutesName.home ||
                      ModalRoute.of(context)?.settings.name ==
                          RoutesName.hometracking;
              if (!isOnHomePage) {
                Navigator.pushReplacementNamed(context, RoutesName.home);
                return false;
              }
              return true;
            },
            child: child!,
          );
        },
      ),
    );
  }

  String determineInitialRoute(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user role from Firestore
      String userRole =
          Provider.of<UserChoiceProvider>(context, listen: false).userChoice;
      return userRole == 'Track' ? RoutesName.home : RoutesName.hometracking;
    }
    return RoutesName.start; // Default route if user is not logged in
  }
}
