import 'package:flutter/material.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/add_contact.dart';
import 'package:gentech/view/To%20Be%20Tracked/add_number.dart';
import 'package:gentech/view/To%20Be%20Tracked/alert_screen.dart';
import 'package:gentech/view/To%20Be%20Tracked/forgot_password.dart';
import 'package:gentech/view/To%20Be%20Tracked/home.dart';
import 'package:gentech/view/To%20Be%20Tracked/login_or_signup.dart';
import 'package:gentech/view/To%20Be%20Tracked/notification.dart';
import 'package:gentech/view/To%20Be%20Tracked/payment_screens.dart';
import 'package:gentech/view/To%20Be%20Tracked/profile_screen.dart';
import 'package:gentech/view/To%20Be%20Tracked/reset_password.dart';
import 'package:gentech/view/To%20Be%20Tracked/side_drawer.dart';
import 'package:gentech/view/To%20Be%20Tracked/sign_in.dart';
import 'package:gentech/view/To%20Be%20Tracked/sign_up.dart';
import 'package:gentech/view/To%20Be%20Tracked/verification_screen.dart';
import 'package:gentech/view/Tracking/home_tracking.dart';
import 'package:gentech/view/Tracking/live_tracking.dart';
import 'package:gentech/view/Tracking/set_reminder.dart';
import 'package:gentech/view/Tracking/tracking_alert.dart';
import 'package:gentech/view/Tracking/tracking_location.dart';
import 'package:gentech/view/Tracking/unlock_phone.dart';
import 'package:gentech/view/splashscreen.dart';
import 'package:gentech/view/start.dart';

class Routes {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.start:
        return MaterialPageRoute(builder: (_) => const Start());
      case RoutesName.splashscreen:
        return MaterialPageRoute(builder: (_) => const Splashscreen());
      case RoutesName.loginOrSignup:
        return MaterialPageRoute(builder: (_) => const LoginOrSignup());
      case RoutesName.signin:
        return MaterialPageRoute(builder: (_) => const SignIn());
      case RoutesName.signup:
        return MaterialPageRoute(builder: (_) => const SignUp());
      case RoutesName.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case RoutesName.verification:
        return MaterialPageRoute(builder: (_) => const VerificationScreen());
      case RoutesName.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPassword());
      case RoutesName.home:
        return MaterialPageRoute(builder: (_) => const Home());
      case RoutesName.addNumber:
        return MaterialPageRoute(builder: (_) => const AddNumber());
      case RoutesName.addcontact:
        return MaterialPageRoute(builder: (_) => const AddContact());
      case RoutesName.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case RoutesName.notification:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());
      case RoutesName.alert:
        return MaterialPageRoute(builder: (_) => const AlertScreen());
      case RoutesName.hometracking:
        return MaterialPageRoute(builder: (_) => const HomeTracking());
      case RoutesName.unlockphone:
        return MaterialPageRoute(builder: (_) => const UnlockPhone());
      case RoutesName.setreminder:
        return MaterialPageRoute(builder: (_) => const SetReminder());
      case RoutesName.trackinglocation:
        return MaterialPageRoute(builder: (_) => const TrackingLocation());
      case RoutesName.livetracking:
        return MaterialPageRoute(builder: (_) => const LiveTracking());
      case RoutesName.trackingAlert:
        return MaterialPageRoute(builder: (_) => const TrackingAlert());
      case RoutesName.trackingaddnumber:
      // return MaterialPageRoute(builder: (_) => const TrackingAddNumber());
      case RoutesName.paymentscreen:
        return MaterialPageRoute(builder: (_) => const PaymentScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }

  static Widget getRouteWidget(String routeName) {
    switch (routeName) {
      case RoutesName.start:
        return const Start();
      case RoutesName.splashscreen:
        return const Splashscreen();
      case RoutesName.loginOrSignup:
        return const LoginOrSignup();
      case RoutesName.signin:
        return const SignIn();
      case RoutesName.signup:
        return const SignUp();
      case RoutesName.forgotPassword:
        return const ForgotPassword();
      case RoutesName.verification:
        return const VerificationScreen();
      case RoutesName.resetPassword:
        return const ResetPassword();
      case RoutesName.home:
        return const Home();
      case RoutesName.addNumber:
        return const AddNumber();
      case RoutesName.addcontact:
        return const AddContact();
      case RoutesName.profile:
        return const ProfileScreen();
      case RoutesName.notification:
        return const NotificationScreen();
      case RoutesName.alert:
        return const AlertScreen();
      case RoutesName.hometracking:
        return const HomeTracking();
      case RoutesName.unlockphone:
        return const UnlockPhone();
      case RoutesName.setreminder:
        return const SetReminder();
      case RoutesName.trackinglocation:
        return const TrackingLocation();
      case RoutesName.livetracking:
        return const LiveTracking();
      case RoutesName.trackingAlert:
        return const TrackingAlert();
      case RoutesName.trackingaddnumber:
      // return const TrackingAddNumber();
      case RoutesName.paymentscreen:
        return const PaymentScreen();
      case RoutesName.drawer:
        return const SideDrawer();

      default:
        return Scaffold(
          body: Center(
            child: Text('No route defined for $routeName'),
          ),
        );
    }
  }
}
