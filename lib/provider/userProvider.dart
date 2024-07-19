import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gentech/model/userModel.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  String? get userRole => null;

  Future<void> fetchUserData(String userRole) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection(userRole == 'Track' ? 'trackUsers' : 'trackingUsers')
            .doc(currentUser.uid)
            .get();

        if (doc.exists) {
          _user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        } else {
          print("No such document!");
          _user = null;
        }
      } else {
        print("No user is signed in.");
        _user = null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      _user = null;
    }
    notifyListeners();
  }

  Future<void> updateUserData(UserModel userModel, String userRole) async {
    try {
      await FirebaseFirestore.instance
          .collection(userRole == 'Track' ? 'trackUsers' : 'trackingUsers')
          .doc(userModel.uid)
          .set(userModel.toMap());
      _user = userModel;
      notifyListeners();
    } catch (e) {
      print("Error updating user data: $e");
    }
  }
}
