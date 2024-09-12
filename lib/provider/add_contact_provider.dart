// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AddContactProvider with ChangeNotifier {
//   List<Contact> contacts = [];
//   List<Contact> filteredContacts = [];
//   List searchResult = [];
//   Map<String, dynamic>? selectedUser;

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController searchController = TextEditingController();

//   Future<void> getContactPermission() async {
//     if (await Permission.contacts.isGranted) {
//       await fetchContacts();
//     } else {
//       await Permission.contacts.request();
//       if (await Permission.contacts.isGranted) {
//         await fetchContacts();
//       }
//     }
//   }

//   Future<void> fetchContacts() async {
//     contacts = await ContactsService.getContacts();
//     notifyListeners();
//   }

//   void filterContacts(String query) {
//     if (query.isEmpty) {
//       filteredContacts = [];
//     } else {
//       List<Contact> tempList = [];
//       for (Contact contact in contacts) {
//         // Check if the query matches the contact's name
//         if (contact.displayName != null &&
//             contact.displayName!.toLowerCase().contains(query.toLowerCase())) {
//           tempList.add(contact);
//           continue;
//         }

//         // Check if the query matches any of the contact's phone numbers
//         if (contact.phones != null) {
//           for (Item phone in contact.phones!) {
//             if (phone.value!.contains(query)) {
//               tempList.add(contact);
//               break;
//             }
//           }
//         }
//       }
//       filteredContacts = tempList;
//     }
//     notifyListeners();
//   }

//   void selectContact(Contact contact) {
//     if (contact.phones != null && contact.phones!.isNotEmpty) {
//       phoneNumberController.text = contact.phones!.first.value ?? '';
//       nameController.text = contact.displayName ?? '';
//       filteredContacts = [];
//       notifyListeners();
//     }
//   }

//   void searchFromFirebase(String query, String userRole) async {
//     if (query.isEmpty) {
//       searchResult = [];
//     } else {
//       String collectionToSearch =
//           userRole == 'Track' ? 'trackingUsers' : 'trackUsers';
//       print(userRole);

//       String lowerCaseQuery = query.toLowerCase();

//       final result =
//           await FirebaseFirestore.instance.collection(collectionToSearch).get();

//       searchResult = result.docs.where((doc) {
//         var name = (doc.data()['name'] as String).toLowerCase();
//         return name.startsWith(lowerCaseQuery);
//       }).map((e) {
//         var data = e.data();
//         data['uid'] = e.id; // Storing the document ID as 'uid'
//         return data;
//       }).toList();
//     }
//     notifyListeners();
//   }

//   void selectUser(Map<String, dynamic> user) {
//     selectedUser = user;
//     nameController.text = user['name'] ?? '';
//     phoneNumberController.text = user['phonenumber'] ?? '';
//     emailController.text = user['email'] ?? '';
//     searchResult = [];
//     notifyListeners();
//   }

//   Future<void> addContact(
//       BuildContext context, String userRole, User? loggedInUser) async {
//     try {
//       if (loggedInUser == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.red,
//             content: Text('No user is currently logged in.'),
//           ),
//         );
//         return;
//       }

//       String collectionToSaveIn =
//           userRole == 'Track' ? 'trackUsers' : 'trackingUsers';

//       DocumentReference userDocRef = FirebaseFirestore.instance
//           .collection(collectionToSaveIn)
//           .doc(loggedInUser.uid);

//       if (selectedUser == null) {
//         if (nameController.text.isEmpty ||
//             phoneNumberController.text.isEmpty ||
//             emailController.text.isEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.red,
//               content: Text('Please enter all details to add a contact.'),
//             ),
//           );
//           return;
//         }

//         var existingContacts = await userDocRef
//             .collection('contacts')
//             .where('email', isEqualTo: emailController.text.trim())
//             .where('phonenumber', isEqualTo: phoneNumberController.text.trim())
//             .get();

//         if (existingContacts.docs.isNotEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.red,
//               content: Text('User already exists in your contacts.'),
//             ),
//           );
//           return;
//         }

//         // Generate a dynamic link and send via email
//         final Uri appLink = await createAppLink();
//         await sendEmailWithLink(
//             emailController.text.trim(), appLink.toString());

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.green,
//             content: Text('We sent a link to this email.'),
//           ),
//         );
//       } else {
//         var existingContacts = await userDocRef
//             .collection('contacts')
//             .where('uid', isEqualTo: selectedUser!['uid'])
//             .get();

//         if (existingContacts.docs.isNotEmpty) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               backgroundColor: Colors.red,
//               content: Text('This contact is already added.'),
//             ),
//           );
//           return;
//         }

//         // Add the contact to Firestore under the logged-in user's contacts
//         await userDocRef.collection('contacts').add({
//           'name': nameController.text,
//           'phonenumber': phoneNumberController.text,
//           'email': emailController.text,
//           'uid': selectedUser!['uid'],
//           'imageUrl': selectedUser!['imageUrl'] ?? '',
//           'reference': selectedUser!['uid'] != null
//               ? FirebaseFirestore.instance
//                   .collection(selectedUser!['role'] == 'Track'
//                       ? 'trackUsers'
//                       : 'trackingUsers')
//                   .doc(selectedUser!['uid'])
//                   .path
//               : null,
//         });

//         // Show success message only when contact is added from search
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.green,
//             content: Text('Contact added successfully!'),
//           ),
//         );
//       }

//       // Clear the form fields and reset the state
//       nameController.clear();
//       phoneNumberController.clear();
//       emailController.clear();
//       searchController.clear();
//       selectedUser = null;
//       searchResult = [];
//       filteredContacts = [];

//       notifyListeners();
//     } catch (error) {
//       print('Error adding contact: $error');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           backgroundColor: Colors.red,
//           content: Text('Failed to add contact: $error'),
//         ),
//       );
//     }
//   }

//   Future<Uri> createAppLink() async {
//     final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
//       link: Uri.parse('https://pocketguardian.page.link/app'),
//       uriPrefix: 'https://pocketguardian.page.link',
//       androidParameters: const AndroidParameters(
//         packageName: 'com.example.gentech',
//         minimumVersion: 1,
//       ),
//       iosParameters: const IOSParameters(
//         bundleId: 'com.yourapp.package',
//         minimumVersion: '1.0.0',
//         appStoreId: '123456789',
//       ),
//     );

//     final ShortDynamicLink shortDynamicLink =
//         await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

//     return shortDynamicLink.shortUrl;
//   }

//   Future<void> sendEmailWithLink(String email, String link) async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: email,
//       queryParameters: {
//         'subject': 'Your App Invitation',
//         'body': 'Click this link to proceed: $link'
//       },
//     );

//     if (await canLaunchUrl(emailUri)) {
//       await launchUrl(emailUri);
//     } else {
//       throw 'Could not launch $emailUri';
//     }
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fast_contacts/fast_contacts.dart'; // Updated package
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/material.dart';
// import 'package:gentech/utils/snackbar.dart';
// import 'package:permission_handler/permission_handler.dart';

// class AddContactProvider with ChangeNotifier {
//   List<Contact> contacts = [];
//   List<Contact> filteredContacts = [];
//   List searchResult = [];
//   Map<String, dynamic>? selectedUser;

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController searchController = TextEditingController();

//   Future<void> getContactPermission() async {
//     if (await Permission.contacts.isGranted) {
//       await fetchContacts();
//     } else {
//       await Permission.contacts.request();
//       if (await Permission.contacts.isGranted) {
//         await fetchContacts();
//       }
//     }
//   }

//   Future<void> fetchContacts() async {
//     try {
//       // Using Fast Contacts to get the list of contacts
//       contacts = await FastContacts.getAllContacts();
//       notifyListeners();
//     } catch (e) {
//       print('Failed to fetch contacts: $e');
//     }
//   }

//   void filterContacts(String query) {
//     if (query.isEmpty) {
//       filteredContacts = [];
//     } else {
//       List<Contact> tempList = [];
//       for (Contact contact in contacts) {
//         // Check if the query matches the contact's name
//         if (contact.displayName.toLowerCase().contains(query.toLowerCase())) {
//           tempList.add(contact);
//           continue;
//         }

//         // Check if the query matches any of the contact's phone numbers
//         if (contact.phones.isNotEmpty) {
//           for (Phone phone in contact.phones) {
//             if (phone.number.contains(query)) {
//               // Access the phone number using phone.number
//               tempList.add(contact);
//               break;
//             }
//           }
//         }
//       }
//       filteredContacts = tempList;
//     }
//     notifyListeners();
//   }

//   void selectContact(Contact contact) {
//     if (contact.phones.isNotEmpty) {
//       phoneNumberController.text = contact.phones.first
//           .number; // Accessing the phone number from the 'Phone' object
//       nameController.text = contact.displayName ?? '';
//       filteredContacts = [];
//       notifyListeners();
//     }
//   }

//   void searchFromFirebase(String query, String userRole) async {
//     if (query.isEmpty) {
//       searchResult = [];
//     } else {
//       String collectionToSearch =
//           userRole == 'Track' ? 'trackingUsers' : 'trackUsers';

//       String lowerCaseQuery = query.toLowerCase();

//       final result =
//           await FirebaseFirestore.instance.collection(collectionToSearch).get();

//       searchResult = result.docs.where((doc) {
//         var name = (doc.data()['name'] as String).toLowerCase();
//         return name.startsWith(lowerCaseQuery);
//       }).map((e) {
//         var data = e.data();
//         data['uid'] = e.id; // Storing the document ID as 'uid'
//         return data;
//       }).toList();
//     }
//     notifyListeners();
//   }

//   void selectUser(Map<String, dynamic> user) {
//     selectedUser = user;
//     nameController.text = user['name'] ?? '';
//     phoneNumberController.text = user['phonenumber'] ?? '';
//     emailController.text = user['email'] ?? '';
//     searchResult = [];
//     notifyListeners();
//   }

//   Future<void> addContact(
//       BuildContext context, String userRole, User? loggedInUser) async {
//     try {
//       if (loggedInUser == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             backgroundColor: Colors.red,
//             content: Text('No user is currently logged in.'),
//           ),
//         );
//         return;
//       }

//       String collectionToSaveIn =
//           userRole == 'Track' ? 'trackUsers' : 'trackingUsers';

//       DocumentReference userDocRef = FirebaseFirestore.instance
//           .collection(collectionToSaveIn)
//           .doc(loggedInUser.uid);

//       if (selectedUser == null) {
//         if (nameController.text.isEmpty ||
//             phoneNumberController.text.isEmpty ||
//             emailController.text.isEmpty) {
//           showTopSnackBar(context, 'Please enter all details to add a contact.',
//               Colors.red);

//           return;
//         }

//         var existingContacts = await userDocRef
//             .collection('contacts')
//             .where('email', isEqualTo: emailController.text.trim())
//             .where('phonenumber', isEqualTo: phoneNumberController.text.trim())
//             .get();

//         if (existingContacts.docs.isNotEmpty) {
//           showTopSnackBar(
//               context, 'User already exists in your contacts.', Colors.green);

//           return;
//         }

//         // Generate a dynamic link and send via email
//         final Uri appLink = await createAppLink();
//         await sendEmailWithLink(
//             emailController.text.trim(), appLink.toString());
//         showTopSnackBar(context, 'We sent a link to this email.', Colors.green);
//       } else {
//         var existingContacts = await userDocRef
//             .collection('contacts')
//             .where('uid', isEqualTo: selectedUser!['uid'])
//             .get();

//         if (existingContacts.docs.isNotEmpty) {
//           showTopSnackBar(
//               context, 'This contact is already added.', Colors.red);
//           return;
//         }

//         // Add the contact to Firestore under the logged-in user's contacts
//         await userDocRef.collection('contacts').add({
//           'name': nameController.text,
//           'phonenumber': phoneNumberController.text,
//           'email': emailController.text,
//           'uid': selectedUser!['uid'],
//           'imageUrl': selectedUser!['imageUrl'] ?? '',
//           'reference': selectedUser!['uid'] != null
//               ? FirebaseFirestore.instance
//                   .collection(selectedUser!['role'] == 'Track'
//                       ? 'trackUsers'
//                       : 'trackingUsers')
//                   .doc(selectedUser!['uid'])
//                   .path
//               : null,
//         });
//         showTopSnackBar(context, 'Contact added successfully!', Colors.green);
//       }

//       // Clear the form fields and reset the state
//       nameController.clear();
//       phoneNumberController.clear();
//       emailController.clear();
//       searchController.clear();
//       selectedUser = null;
//       searchResult = [];
//       filteredContacts = [];

//       notifyListeners();
//     } catch (error) {
//       print('Error adding contact: $error');
//       showTopSnackBar(context, 'Failed to add contact: $error', Colors.red);
//     }
//   }

//   Future<Uri> createAppLink() async {
//     final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
//       link: Uri.parse('https://pocketguardian.page.link/app'),
//       uriPrefix: 'https://pocketguardian.page.link',
//       androidParameters: const AndroidParameters(
//         packageName: 'com.example.gentech',
//         minimumVersion: 1,
//       ),
//       iosParameters: const IOSParameters(
//         bundleId: 'com.yourapp.package',
//         minimumVersion: '1.0.0',
//         appStoreId: '123456789',
//       ),
//     );

//     final ShortDynamicLink shortDynamicLink =
//         await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

//     return shortDynamicLink.shortUrl;
//   }

//   Future<void> sendEmailWithLink(String email, String link) async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: email,
//       queryParameters: {
//         'subject': 'Your App Invitation',
//         'body': 'Click this link to proceed: $link'
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_contacts/fast_contacts.dart'; // Updated package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:gentech/utils/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class AddContactProvider with ChangeNotifier {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  List searchResult = [];
  Map<String, dynamic>? selectedUser;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  Future<void> getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      await fetchContacts();
    } else {
      await Permission.contacts.request();
      if (await Permission.contacts.isGranted) {
        await fetchContacts();
      }
    }
  }

  Future<void> fetchContacts() async {
    try {
      // Using Fast Contacts to get the list of contacts
      contacts = await FastContacts.getAllContacts();
      notifyListeners();
    } catch (e) {
      print('Failed to fetch contacts: $e');
    }
  }

  void filterContacts(String query) {
    if (query.isEmpty) {
      filteredContacts = [];
    } else {
      List<Contact> tempList = [];
      for (Contact contact in contacts) {
        // Check if the query matches the contact's name
        if (contact.displayName.toLowerCase().contains(query.toLowerCase())) {
          tempList.add(contact);
          continue;
        }

        // Check if the query matches any of the contact's phone numbers
        if (contact.phones.isNotEmpty) {
          for (Phone phone in contact.phones) {
            if (phone.number.contains(query)) {
              // Access the phone number using phone.number
              tempList.add(contact);
              break;
            }
          }
        }
      }
      filteredContacts = tempList;
    }
    notifyListeners();
  }

  void selectContact(Contact contact) {
    if (contact.phones.isNotEmpty) {
      phoneNumberController.text = contact.phones.first
          .number; // Accessing the phone number from the 'Phone' object
      nameController.text = contact.displayName;
      filteredContacts = [];
      notifyListeners();
    }
  }

  void searchFromFirebase(String query, String userRole) async {
    if (query.isEmpty) {
      searchResult = [];
    } else {
      String collectionToSearch =
          userRole == 'Track' ? 'trackingUsers' : 'trackUsers';

      String lowerCaseQuery = query.toLowerCase();

      final result =
          await FirebaseFirestore.instance.collection(collectionToSearch).get();

      searchResult = result.docs.where((doc) {
        var name = (doc.data()['name'] as String).toLowerCase();
        return name.startsWith(lowerCaseQuery);
      }).map((e) {
        var data = e.data();
        data['uid'] = e.id; // Storing the document ID as 'uid'
        return data;
      }).toList();
    }
    notifyListeners();
  }

  void selectUser(Map<String, dynamic> user) {
    selectedUser = user;
    nameController.text = user['name'] ?? '';
    phoneNumberController.text = user['phonenumber'] ?? '';
    emailController.text = user['email'] ?? '';
    searchResult = [];
    notifyListeners();
  }

  Future<void> addContact(
      BuildContext context, String userRole, User? loggedInUser) async {
    try {
      if (loggedInUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('No user is currently logged in.'),
          ),
        );
        return;
      }

      String collectionToSaveIn =
          userRole == 'Track' ? 'trackUsers' : 'trackingUsers';

      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection(collectionToSaveIn)
          .doc(loggedInUser.uid);

      if (selectedUser == null) {
        if (nameController.text.isEmpty ||
            phoneNumberController.text.isEmpty ||
            emailController.text.isEmpty) {
          showTopSnackBar(context, 'Please enter all details to add a contact.',
              Colors.red);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     backgroundColor: Colors.red,
          //     content: Text('Please enter all details to add a contact.'),
          //   ),
          // );
          return;
        }

        var existingContacts = await userDocRef
            .collection('contacts')
            .where('email', isEqualTo: emailController.text.trim())
            .where('phonenumber', isEqualTo: phoneNumberController.text.trim())
            .get();

        if (existingContacts.docs.isNotEmpty) {
          showTopSnackBar(
              context, 'User already exists in your contacts.', Colors.green);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     backgroundColor: Colors.red,
          //     content: Text('User already exists in your contacts.'),
          //   ),
          // );
          return;
        }

        // Generate a dynamic link and send via email
        final Uri appLink = await createAppLink();
        await sendEmailWithLink(
            emailController.text.trim(), appLink.toString());
        // showTopSnackBar(context, 'We sent a link to this email.', Colors.green);
      } else {
        var existingContacts = await userDocRef
            .collection('contacts')
            .where('uid', isEqualTo: selectedUser!['uid'])
            .get();

        if (existingContacts.docs.isNotEmpty) {
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     backgroundColor: Colors.red,
          //     content: Text('This contact is already added.'),
          //   ),
          // );

          showTopSnackBar(
              context, 'This contact is already added.', Colors.red);
          return;
        }

        // Add the contact to Firestore under the logged-in user's contacts
        await userDocRef.collection('contacts').add({
          'name': nameController.text,
          'phonenumber': phoneNumberController.text,
          'email': emailController.text,
          'uid': selectedUser!['uid'],
          'imageUrl': selectedUser!['imageUrl'] ?? '',
          'reference': selectedUser!['uid'] != null
              ? FirebaseFirestore.instance
                  .collection(selectedUser!['role'] == 'Track'
                      ? 'trackUsers'
                      : 'trackingUsers')
                  .doc(selectedUser!['uid'])
                  .path
              : null,
        });
        showTopSnackBar(context, 'Contact added successfully!', Colors.green);
        // Show success message only when contact is added from search
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     backgroundColor: Colors.green,
        //     content: Text('Contact added successfully!'),
        //   ),
        // );
      }

      // Clear the form fields and reset the state
      nameController.clear();
      phoneNumberController.clear();
      emailController.clear();
      searchController.clear();
      selectedUser = null;
      searchResult = [];
      filteredContacts = [];

      notifyListeners();
    } catch (error) {
      print('Error adding contact: $error');
      showTopSnackBar(context, 'Failed to add contact: $error', Colors.red);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: Colors.red,
      //     content: Text('Failed to add contact: $error'),
      //   ),
      // );
    }
  }

  Future<Uri> createAppLink() async {
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse('https://pocketguardian.page.link/app'),
      uriPrefix: 'https://pocketguardian.page.link',
      androidParameters: const AndroidParameters(
        packageName: 'com.example.gentech',
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.yourapp.package',
        minimumVersion: '1.0.0',
        appStoreId: '123456789',
      ),
    );

    final ShortDynamicLink shortDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);

    return shortDynamicLink.shortUrl;
  }

  Future<void> sendEmailWithLink(String email, String link) async {
    String body = 'Click this link to proceed: $link';

    String encodedBody = Uri.encodeComponent(body);
    await launchUrl(Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Your App Invitation&body=$encodedBody',
      // queryParameters: {
      //   'subject': 'Your App Invitation',
      //   'body': 'Click this link to proceed: $link'
      // },
    ));
  }
}
