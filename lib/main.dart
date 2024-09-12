import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gentech/app%20notification/push_notification.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/firebase_options.dart';
import 'package:gentech/provider/add_contact_provider.dart';
import 'package:gentech/provider/contact_provider.dart';
import 'package:gentech/provider/marker_Provider.dart';
import 'package:gentech/provider/navigationProvider.dart';
import 'package:gentech/provider/option_provider.dart';
import 'package:gentech/provider/places_provider.dart';
import 'package:gentech/provider/profile_Provider.dart';
import 'package:gentech/provider/subscription_provider.dart';
import 'package:gentech/provider/tracking_bottom_bar_Provider.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/routes/routes.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Assign publishable key to flutter_stripe
  Stripe.publishableKey =
      "pk_test_51PjJcmH6pq5VX25Ch7Cc5USlqUeMmbLhlEgfzGIycxZO4eETI1SGHeaRpBdTpcFqlU2bhngfkQStCoJB7nOYomDY006xfWMEPg";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize WorkManager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => TrackingBottomBarProvider()),
        ChangeNotifierProvider(create: (_) => UserChoiceProvider()),
        ChangeNotifierProvider(create: (_) => OptionProvider()),
        ChangeNotifierProvider(create: (_) => MarkerProvider()),
        ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ChangeNotifierProvider(create: (_) => LocationPlacesProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => AddContactProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Ensure Firebase is initialized in the background
    await Firebase.initializeApp();

    print("Callback Dispatcher Started");
    if (task == "reminderTask") {
      print("Executing Task: $task");
      await sendNotification(inputData);
    }
    return Future.value(true);
  });
}

Future<void> sendNotification(Map<String, dynamic>? inputData) async {
  if (inputData == null) return;

  String deviceToken = inputData['deviceToken'];
  String uid = inputData['uid'];
  String senderId = inputData['senderId'];
  String mapsUrl = inputData['mapsUrl'];
  String body = "Reminder! Check the location: $mapsUrl";

  try {
    await PushNotification.sendNotificationToSelectedRole(
      deviceToken,
      null, // context null hoga background mein
      senderId,
      uid,
      inputData['latitude'],
      inputData['longitude'],
      "Reminder Notification",
      body,
    );
  } catch (e) {
    print('Error sending notification: $e');
  }
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
      // designSize: const Size(390, 791),
      builder: (context, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'The Pocket Guardian',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.white,
        ),
        home: FutureBuilder<String>(
          future: determineInitialRoute(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Or any loading screen
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Error determining initial route'));
            } else {
              return Routes.getRouteWidget(snapshot.data!);
            }
          },
        ),
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }

  Future<String> determineInitialRoute() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userRole = prefs.getString('userChoice');
      if (userRole != null) {
        return userRole == 'Track' ? RoutesName.home : RoutesName.hometracking;
      }
    }
    return RoutesName
        .start; // Default route if user is not logged in or role not found
  }
}
