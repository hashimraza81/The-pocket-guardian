import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gentech/model/contact_model.dart';
import 'package:gentech/provider/user_choice_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  bool _isLoading = true;

  List<Contact> get contacts => _contacts;
  bool get isLoading => _isLoading;

  ContactProvider() {
    _loadContactsFromCache();
  }

  Future<void> _loadContactsFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsJson = prefs.getString('contacts');
    if (contactsJson != null) {
      List<dynamic> contactsList = jsonDecode(contactsJson);
      _contacts = contactsList.map((data) => Contact.fromJson(data)).toList();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchContacts(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userRole =
          Provider.of<UserChoiceProvider>(context, listen: false).userChoice;
      String collectionToSearch =
          userRole == 'Track' ? 'trackUsers' : 'trackingUsers';

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(collectionToSearch)
          .doc(user.uid)
          .collection('contacts')
          .get();

      _contacts = snapshot.docs.map((doc) {
        return Contact.fromFirestore(doc);
      }).toList();

      // Save to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String contactsJson =
          jsonEncode(_contacts.map((contact) => contact.toJson()).toList());
      prefs.setString('contacts', contactsJson);

      _isLoading = false;
      notifyListeners();
    }
  }
}
