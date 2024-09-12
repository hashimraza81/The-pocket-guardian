import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gentech/routes/routes_names.dart';

class SubscriptionProvider with ChangeNotifier {
  bool _isSubscribed = false;
  bool get isSubscribed => _isSubscribed;

  Future<void> checkSubscriptionStatus() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    String? collectionName;

    // Check in trackingUsers collection
    DocumentSnapshot trackingUserDoc = await FirebaseFirestore.instance
        .collection('trackingUsers')
        .doc(userId)
        .get();

    if (trackingUserDoc.exists) {
      collectionName = 'trackingUsers';
    } else {
      // Check in trackUsers collection
      DocumentSnapshot trackedUserDoc = await FirebaseFirestore.instance
          .collection('trackUsers')
          .doc(userId)
          .get();

      if (trackedUserDoc.exists) {
        collectionName = 'trackUsers';
      }
    }

    if (collectionName != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(userId)
          .get();
      _isSubscribed = userDoc.data()?['subscribed'] ?? false;
      notifyListeners();
    }
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

  Future<bool> canAddContact(BuildContext context) async {
    // Show loading indicator only when navigating to a new screen
    _showLoadingIndicator(context);

    final userId = FirebaseAuth.instance.currentUser!.uid;
    String? collectionName;

    DocumentSnapshot trackingUserDoc = await FirebaseFirestore.instance
        .collection('trackingUsers')
        .doc(userId)
        .get();

    if (trackingUserDoc.exists) {
      collectionName = 'trackingUsers';
    } else {
      DocumentSnapshot trackedUserDoc = await FirebaseFirestore.instance
          .collection('trackUsers')
          .doc(userId)
          .get();

      if (trackedUserDoc.exists) {
        collectionName = 'trackUsers';
      }
    }

    if (collectionName == null) {
      Navigator.of(context).pop(); // Hide loading indicator
      return false;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(userId)
        .get();
    final bool subscribedStatus = userDoc.data()?['subscribed'] ?? false;

    if (subscribedStatus) {
      Navigator.of(context).pop(); // Hide loading indicator
      Navigator.pushNamed(context, RoutesName.addcontact);
      return true;
    }

    final contactsCollection = FirebaseFirestore.instance
        .collection(collectionName)
        .doc(userId)
        .collection('contacts');

    final contactCount =
        await contactsCollection.get().then((snapshot) => snapshot.size);

    Navigator.of(context).pop(); // Hide loading indicator

    if (contactCount >= 1) {
      _showAlert(context);
      return false;
    }

    Navigator.pushNamed(context, RoutesName.addcontact);
    return true;
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limit Reached'),
          content: const Text(
            'You cannot add more contacts without a subscription.',
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, RoutesName.paymentscreen);
              },
              child: const Text(
                'Subscribe',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
