import 'dart:async';
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
  StreamSubscription? _subscription;

  List<Contact> get contacts => _contacts;
  bool get isLoading => _isLoading;

  ContactProvider() {
    loadContactsFromCache();
  }

  Future<void> loadContactsFromCache() async {
    _isLoading = true; // Ensure loading state is true initially
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsJson = prefs.getString('contacts');
    if (contactsJson != null) {
      List<dynamic> contactsList = jsonDecode(contactsJson);
      _contacts = contactsList.map((data) => Contact.fromJson(data)).toList();
      print('Contacts loaded from cache: $_contacts');
    } else {
      print('No contacts found in cache');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> subscribeToContacts(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userRole =
          Provider.of<UserChoiceProvider>(context, listen: false).userChoice;
      String collectionToSearch =
          userRole == 'Track' ? 'trackUsers' : 'trackingUsers';

      _subscription = FirebaseFirestore.instance
          .collection(collectionToSearch)
          .doc(user.uid)
          .collection('contacts')
          .snapshots()
          .listen((snapshot) {
        _contacts = snapshot.docs.map((doc) {
          return Contact.fromFirestore(doc);
        }).toList();

        // Save to SharedPreferences
        SharedPreferences.getInstance().then((prefs) {
          String contactsJson =
              jsonEncode(_contacts.map((contact) => contact.toJson()).toList());
          prefs.setString('contacts', contactsJson);
          print('Contacts updated from Firestore: ${_contacts.length}');
        });

        _isLoading = false;
        notifyListeners();
      });
    } else {
      print('User is not logged in');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteContact(String documentId, BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userRole =
          Provider.of<UserChoiceProvider>(context, listen: false).userChoice;
      String collectionToSearch =
          userRole == 'Track' ? 'trackUsers' : 'trackingUsers';

      try {
        await FirebaseFirestore.instance
            .collection(collectionToSearch)
            .doc(user.uid)
            .collection('contacts')
            .doc(documentId) // Use the Firestore document ID
            .delete();

        print('Contact document deleted successfully from Firestore.');

        // Update the local list and notify listeners
        _contacts.removeWhere((contact) => contact.id == documentId);
        notifyListeners();

        // Update SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String contactsJson =
            jsonEncode(_contacts.map((contact) => contact.toJson()).toList());
        prefs.setString('contacts', contactsJson);
      } catch (e) {
        print('Failed to delete contact document from Firestore: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error deleting contact. Please try again.')),
        );
      }
    } else {
      print('User is not logged in');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
