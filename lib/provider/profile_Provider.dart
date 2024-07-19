import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileProvider with ChangeNotifier {
  String _profileImageUrl = '';
  String _username = '';

  String get profileImageUrl => _profileImageUrl;
  String get username => _username;

  Future<void> fetchUserProfile(BuildContext context, String userRole) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(userRole == 'Track' ? 'trackUsers' : 'trackingUsers')
          .doc(user.uid)
          .get();

      _username = userDoc['name'];
      _profileImageUrl = userDoc['imageUrl'];

      notifyListeners();
    }
  }
}
