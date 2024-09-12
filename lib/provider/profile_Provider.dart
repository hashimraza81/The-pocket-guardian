import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider with ChangeNotifier {
  String _profileImageUrl = '';
  String _username = '';

  String get profileImageUrl => _profileImageUrl;
  String get username => _username;
  bool isLoading = true; // Loading state flag

  // Constructor that automatically loads user profile from cache
  UserProfileProvider() {
    _loadUserProfileFromCache();
  }

  // Load cached user profile data from SharedPreferences
  Future<void> _loadUserProfileFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? '';
    _profileImageUrl = prefs.getString('profileImageUrl') ?? '';
    isLoading = false; // Set isLoading to false after loading from cache
    notifyListeners();
  }

  // Fetch user profile from Firestore only if it hasn't been cached
  Future<void> fetchUserProfile(BuildContext context, String userRole) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the profile data is already cached
    String? cachedUsername = prefs.getString('username');
    String? cachedProfileImageUrl = prefs.getString('profileImageUrl');

    if (cachedUsername != null && cachedProfileImageUrl != null) {
      // Use cached data if available
      _username = cachedUsername;
      _profileImageUrl = cachedProfileImageUrl;
      isLoading = false; // No need to fetch, so stop loading
      notifyListeners();
      return;
    }

    // If no cached data is found, fetch from Firestore
    isLoading = true; // Set loading to true before fetching
    notifyListeners(); // Notify listeners about the state change

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection(userRole == 'Track' ? 'trackUsers' : 'trackingUsers')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          _username = userDoc['name'];
          _profileImageUrl = userDoc['imageUrl'];

          // Save to SharedPreferences
          await prefs.setString('username', _username);
          await prefs.setString('profileImageUrl', _profileImageUrl);
        } else {
          // Handle the case when the document does not exist
          _username = 'Unknown';
          _profileImageUrl = ''; // Fallback to no image
        }
      }
    } catch (error) {
      // Handle any errors (e.g., network issues)
      print("Error fetching user profile: $error");
    } finally {
      isLoading = false; // Set loading to false after fetching
      notifyListeners(); // Notify listeners about the state change
    }
  }

  // Clear user profile data from cache
  Future<void> clearUserProfileCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // print('cls cache');
    notifyListeners(); // Notify listeners about the state change
  }
}
