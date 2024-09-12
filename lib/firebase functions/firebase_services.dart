import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gentech/provider/profile_Provider.dart';
import 'package:gentech/provider/provider.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:gentech/utils/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseFunctions {
  static Future<void> signUpFunction(
    BuildContext context,
    String email,
    String password,
    String username,
    String phonenumber,
    String? imageUrl,
    bool? subscribed,
    String userRole,
  ) async {
    email = email.trim();
    password = password.trim();
    if (email.isEmpty || password.isEmpty) {
      customAlertBox(context, 'Enter required fields');
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // String userRole =
      //     Provider.of<UserChoiceProvider>(context, listen: false).userChoice;

      CollectionReference users = FirebaseFirestore.instance
          .collection(userRole == 'Track' ? 'trackUsers' : 'trackingUsers');

      // Obtain the device token
      String? deviceToken = await FirebaseMessaging.instance.getToken();

      await users.doc(userCredential.user!.uid).set({
        'email': email,
        'name': username,
        'phonenumber': phonenumber,
        'imageUrl': imageUrl,
        'role': userRole,
        'deviceToken': deviceToken,
        'isEmailVerified': false,
        'subscribed': false // Store email verification status
      });

      // Save user role in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userChoice', userRole);

      showTopSnackBar(
        context,
        'Sign Up Successful.',
        Colors.green,
      );

      // Navigate to sign-in screen
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.signin, (route) => false);
    } on FirebaseAuthException catch (ex) {
      customAlertBox(context, ex.code.toString());
    } catch (error) {
      print('Error creating user: $error');
    }
  }

  // sign in fucntion

  static void signInFunction(
    BuildContext context,
    String email,
    String password,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      customAlertBox(context, 'Please enter both email and password');
      return; // Exit early if fields are empty
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Check if the email is verified
      // if (!userCredential.user!.emailVerified) {
      //   customAlertBox(context, 'Please verify your email before signing in.');
      //   await FirebaseAuth.instance.signOut(); // Sign out the user
      //   return;
      // }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Obtain the current device token
      String? currentDeviceToken = await FirebaseMessaging.instance.getToken();

      // Get the instance of UserChoiceProvider
      final userChoiceProvider =
          Provider.of<UserChoiceProvider>(context, listen: false);

      // Try to find the user in trackUsers collection
      DocumentSnapshot trackUserDoc = await FirebaseFirestore.instance
          .collection('trackUsers')
          .doc(userCredential.user!.uid)
          .get();

      if (trackUserDoc.exists) {
        // User found in trackUsers collection
        await _updateDeviceTokenIfNeeded(trackUserDoc, currentDeviceToken);

        // Update the UserChoiceProvider with the 'Track' role
        userChoiceProvider.setUserChoice('Track');

        // Save user role in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userChoice', 'Track');

        // Navigate to home and fetch fresh data after login
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.home, (route) => false).then((_) {
          // Fetch fresh data after navigation
          final profileProvider =
              Provider.of<ProfileProvider>(context, listen: false);
          profileProvider.fetchUserData(); // Fetch data based on role
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //       backgroundColor: Colors.green,
        //       content: Text('User signed in successfully')),
        // );
        showTopSnackBar(context, 'User signed in successfully', Colors.green);

        return;
      }

      // Try to find the user in trackingUsers collection
      DocumentSnapshot trackingUserDoc = await FirebaseFirestore.instance
          .collection('trackingUsers')
          .doc(userCredential.user!.uid)
          .get();

      if (trackingUserDoc.exists) {
        // User found in trackingUsers collection
        await _updateDeviceTokenIfNeeded(trackingUserDoc, currentDeviceToken);

        // Update the UserChoiceProvider with the 'Tracking' role
        userChoiceProvider.setUserChoice('Tracking');

        // Save user role in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userChoice', 'Tracking');

        // Navigate to home and fetch fresh data after login
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.hometracking, (route) => false).then((_) {
          // Fetch fresh data after navigation
          final profileProvider =
              Provider.of<ProfileProvider>(context, listen: false);
          profileProvider.fetchUserData(); // Fetch data based on role
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('User signed in successfully')),
        // );

        showTopSnackBar(
          context,
          'User signed in successfully ',
          Colors.green,
        );
        return;
      }

      // If user is not found in any collection, show an error
      customAlertBox(context, 'User role not found.');
    } on FirebaseAuthException catch (ex) {
      // Handle FirebaseAuthException specifically
      String errorMessage;
      switch (ex.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'user-disabled':
          errorMessage = 'User account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        default:
          errorMessage = 'Error: ${ex.message}';
      }
      customAlertBox(context, errorMessage);
    } catch (error) {
      // Handle any other errors
      print('Error signing in user: $error');
      customAlertBox(context, 'An unexpected error occurred: $error');
    }
  }

  static Future<void> _updateDeviceTokenIfNeeded(
    DocumentSnapshot userDoc,
    String? currentDeviceToken,
  ) async {
    String? storedDeviceToken = userDoc.get('deviceToken');

    if (storedDeviceToken != currentDeviceToken) {
      // Update the device token in Firestore
      await userDoc.reference.update({
        'deviceToken': currentDeviceToken,
      });
    }
  }

//logout function

  static void logoutFunction(BuildContext context) async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Clear cached data from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Clear all stored keys except certain ones (if necessary)
      await prefs.clear(); // This will clear all SharedPreferences data

      // If you want to clear only specific keys, use:
      await prefs.remove('contacts');
      await prefs
          .remove('userChoice'); // Clear the user role from SharedPreferences

      // Clear user profile cache from providers
      Provider.of<UserProfileProvider>(context, listen: false)
          .clearUserProfileCache();
      Provider.of<UserChoiceProvider>(context, listen: false)
          .clearUserProfileCache();
      // Provider.of<ProfileProvider>(context, listen: false)
      //     .clearUserProfileCache();

      // Navigate to the sign-in screen and remove all previous routes
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.signin, (route) => false);

      // Show a snackbar message
      showTopSnackBar(context, 'User logged out successfully!', Colors.green);
    } catch (e) {
      // Handle logout error
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Error signing out. Please try again.'),
        ),
      );
    }
  }

  // static void logoutFunction(BuildContext context) async {
  //   try {
  //     // Sign out from Firebase
  //     await FirebaseAuth.instance.signOut();

  //     // Clear cached contacts
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.remove('contacts');

  //     // Clear user profile cache
  //     Provider.of<UserProfileProvider>(context, listen: false)
  //         .clearUserProfileCache();

  //     Provider.of<UserChoiceProvider>(context, listen: false)
  //         .clearUserProfileCache();

  //     Provider.of<ProfileProvider>(context, listen: false)
  //         .clearUserProfileCache();

  //     // Navigate to the sign-in screen and remove all previous routes
  //     Navigator.pushNamedAndRemoveUntil(
  //         context, RoutesName.signin, (route) => false);

  //     // Show a snackbar message
  //     showTopSnackBar(context, 'User logged Out successfully!', Colors.green);
  //   } catch (e) {
  //     // Handle logout error
  //     print('Error logging out: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         backgroundColor: Colors.red,
  //         content: Text('Error signing out. Please try again.'),
  //       ),
  //     );
  //   }
  // }

  static customAlertBox(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              )
            ],
          );
        });
  }
}
