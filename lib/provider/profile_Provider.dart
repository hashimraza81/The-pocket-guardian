import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider with ChangeNotifier {
  String _profileImageUrl = '';
  String _username = '';

  String get profileImageUrl => _profileImageUrl;
  String get username => _username;

  UserProfileProvider() {
    _loadUserProfileFromCache();
  }

  Future<void> _loadUserProfileFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? '';
    _profileImageUrl = prefs.getString('profileImageUrl') ?? '';
    notifyListeners();
  }

  Future<void> fetchUserProfile(BuildContext context, String userRole) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection(userRole == 'Track' ? 'trackUsers' : 'trackingUsers')
          .doc(user.uid)
          .get();

      _username = userDoc['name'];
      _profileImageUrl = userDoc['imageUrl'];

      // Save to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', _username);
      prefs.setString('profileImageUrl', _profileImageUrl);

      notifyListeners();
    }
  }

  Future<void> clearUserProfileCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('profileImageUrl');

    _username = '';
    _profileImageUrl = '';
    notifyListeners();
  }
}
