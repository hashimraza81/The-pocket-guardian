import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:gentech/routes/routes_names.dart';
import 'package:provider/provider.dart';

class FirebaseFunctions {
  static Future<void> signUpFunction(
    BuildContext context,
    String email,
    String password,
    String username,
    String phonenumber,
    String? imageUrl,
  ) async {
    if (email.isEmpty || password.isEmpty) {
      customAlertBox(context, 'Enter required fields');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String userRole =
          Provider.of<UserChoiceProvider>(context, listen: false).userChoice;

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
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Sign Up Successful'),
        ),
      );
      // Navigate based on user role
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.signin, (route) => false);
    } on FirebaseAuthException catch (ex) {
      customAlertBox(context, ex.code.toString());
    } catch (error) {
      print('Error creating user: $error');
    }
  }

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

      // Try to find the user in trackUsers collection
      DocumentSnapshot trackUserDoc = await FirebaseFirestore.instance
          .collection('trackUsers')
          .doc(userCredential.user!.uid)
          .get();

      if (trackUserDoc.exists) {
        // User found in trackUsers collection
        Navigator.pushReplacementNamed(context, RoutesName.home);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text('User signed in successfully')),
        );
        return;
      }

      // Try to find the user in trackingUsers collection
      DocumentSnapshot trackingUserDoc = await FirebaseFirestore.instance
          .collection('trackingUsers')
          .doc(userCredential.user!.uid)
          .get();

      if (trackingUserDoc.exists) {
        // User found in trackingUsers collection
        Navigator.pushReplacementNamed(context, RoutesName.hometracking);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User signed in successfully')),
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

  static void logoutFunction(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, RoutesName.signin, (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.green,
          content: Text('User signed Out successfully')),
    );
  }

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
