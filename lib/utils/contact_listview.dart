import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gentech/app%20notification/push_notification.dart';
import 'package:gentech/const/app_colors.dart';
import 'package:gentech/model/contact_model.dart';
import 'package:gentech/provider/option_provider.dart';
import 'package:gentech/utils/snackbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/user_choice_provider.dart';

// class ContactListview extends StatelessWidget {

//   final void Function(Contact contact)? onContactSelected;

//   const ContactListview({super.key, this.onContactSelected,});

//   @override
//   Widget build(BuildContext context) {
//     // Get the UID of the currently logged-in user
//     final String? userId = FirebaseAuth.instance.currentUser?.uid;
//      Future<String> determineUserCollection(var userId) async {
//     // Check if user exists in 'trackingUser' collection
//     final trackingUserDoc = await FirebaseFirestore.instance
//         .collection('trackingUsers')
//         .doc(userId)
//         .get();

//     if (trackingUserDoc.exists) {
//       return 'trackingUsers'; // User found in 'trackingUser'
//     }

//     // Check if user exists in 'trackUser' collection
//     final trackUserDoc = await FirebaseFirestore.instance
//         .collection('trackUsers')
//         .doc(userId)
//         .get();

//     if (trackUserDoc.exists) {
//       return 'trackUsers'; // User found in 'trackUser'
//     }

//     throw Exception('User not found in either collection');
//   }
// return FutureBuilder<String>(
//       future: determineUserCollection(userId), // Determine the correct collection
//       builder: (context, collectionSnapshot) {
//         if (collectionSnapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (collectionSnapshot.hasError || !collectionSnapshot.hasData) {
//           return const Center(child: Text("Failed to determine user collection."));
//         }

//         // Get the correct collection name based on the user's presence
//         final collectionName = collectionSnapshot.data!;

//         // Reference to the Firestore subcollection 'contacts' for the specific user
//         final contactsRef = FirebaseFirestore.instance
//             .collection(collectionName)
//             .doc(userId)
//             .collection('contacts');

//         return StreamBuilder<QuerySnapshot>(
//           stream: contactsRef.snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text("No contacts available."));
//             }

//             final contacts = snapshot.data!.docs;

//             return ListView.builder(
//   shrinkWrap: true,
//   itemCount: contacts.length,
//   itemBuilder: (context, index) {
//     // Convert DocumentSnapshot to Contact using fromFirestore factory
//     final contact = Contact.fromFirestore(contacts[index]);

//     return Dismissible(
//       key: Key(contact.id), // Use the Firestore document ID as the key
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         color: Colors.red,
//         child: const Icon(Icons.delete, color: Colors.white),
//       ),
//       confirmDismiss: (direction) async {
//         return await showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text("Are you sure?"),
//               content: const Text("Do you really want to delete this contact?"),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   child: const Text("No"),
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(true),
//                   child: const Text("Yes"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//       onDismissed: (direction) async {
//         await contactsRef.doc(contact.id).delete(); // Delete contact from Firestore
//       },
//       child: InkWell(
//         onTap: () {
//           // Handle navigation if needed
//         },
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: AppColors.secondary.withOpacity(0.09),
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 20.0,
//                     backgroundImage: contact.imageUrl.isNotEmpty
//                         ? NetworkImage(contact.imageUrl)
//                         : null, // No image if the URL is empty
//                     backgroundColor: Colors.transparent,
//                     child: contact.imageUrl.isEmpty
//                         ? const CircleAvatar(
//                             radius: 20,
//                             child: Icon(
//                               Icons.person,
//                               size: 20.0,
//                               color: Colors.grey,
//                             ),
//                           )
//                         : null, // No icon if the URL is not empty
//                   ),
//                   const SizedBox(width: 16.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         contact.name,
//                         style: const TextStyle(
//                           fontSize: 14.0,
//                           fontWeight: FontWeight.w700,
//                           fontFamily: 'Montserrat',
//                           color: AppColors.primary,
//                         ),
//                       ),
//                       Row(
//                         children: [
//                           const Icon(Icons.phone,
//                               size: 16.0, color: AppColors.primary),
//                           const SizedBox(width: 8.0),
//                           Text(
//                             contact.phoneNumber,
//                             style: const TextStyle(
//                               fontSize: 12.0,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Montserrat',
//                               color: AppColors.primary,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   IconButtonWithMenu(
//                     phoneNumber: contact.phoneNumber,
//                     email: contact.email,
//                     contacts: contact, // You can pass JSON if needed
//                     receiverId: contact.uid,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   },
// );
//           },
//         );
//       },
//     );

//     // return ChangeNotifierProvider(
//     //   create: (context) => ContactProvider()..subscribeToContacts(context),
//     //   child: Consumer<ContactProvider>(
//     //     builder: (context, contactProvider, _) {
//     //       if (contactProvider.isLoading) {
//     //         return const Center(child: CircularProgressIndicator());
//     //       }

//     //       // If the contacts are empty after loading, fetch from Firestore
//     //       if (contactProvider.contacts.isEmpty) {
//     //         // contactProvider.subscribeToContacts(context);
//     //       }

//     //       return ListView.builder(
//     //         shrinkWrap: true,
//     //         itemCount: contactProvider.contacts.length,
//     //         itemBuilder: (context, index) {
//     //           final contact = contactProvider.contacts[index];
//     //           print('Key for contact: ${Key(contact.uid)}');
//     //           return Dismissible(
//     //             key:
//     //                 Key(contact.id), // Use the Firestore document ID as the key
//     //             direction: DismissDirection.endToStart,
//     //             background: Container(
//     //               alignment: Alignment.centerRight,
//     //               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//     //               color: Colors.red,
//     //               child: const Icon(Icons.delete, color: Colors.white),
//     //             ),
//     //             confirmDismiss: (direction) async {
//     //               return await showDialog(
//     //                 context: context,
//     //                 builder: (BuildContext context) {
//     //                   return AlertDialog(
//     //                     title: const Text("Are you sure?"),
//     //                     content: const Text(
//     //                         "Do you really want to delete this contact?"),
//     //                     actions: <Widget>[
//     //                       TextButton(
//     //                         style: ButtonStyle(
//     //                           backgroundColor: WidgetStateProperty.all<Color>(
//     //                               AppColors.white), // Background color
//     //                           foregroundColor: WidgetStateProperty.all<Color>(
//     //                               AppColors.primary), // Text color
//     //                           overlayColor: WidgetStateProperty.all<Color>(
//     //                               AppColors.primary
//     //                                   .withOpacity(0.1)), // Ripple effect color
//     //                         ),
//     //                         onPressed: () => Navigator.of(context).pop(false),
//     //                         child: const Text("No"),
//     //                       ),
//     //                       TextButton(
//     //                         onPressed: () => Navigator.of(context).pop(true),
//     //                         style: ButtonStyle(
//     //                           backgroundColor: WidgetStateProperty.all<Color>(
//     //                               AppColors.secondary), // Background color
//     //                           foregroundColor: WidgetStateProperty.all<Color>(
//     //                               AppColors.white), // Text color
//     //                           overlayColor: WidgetStateProperty.all<Color>(
//     //                               AppColors.white
//     //                                   .withOpacity(0.1)), // Ripple effect color
//     //                         ),
//     //                         child: const Text("Yes"),
//     //                       ),
//     //                     ],
//     //                   );
//     //                 },
//     //               );
//     //             },
//     //             onDismissed: (direction) {
//     //               contactProvider.deleteContact(
//     //                   contact.id, context); // Use the document ID
//     //             },
//     //             child: InkWell(
//     //               onTap: onContactSelected != null
//     //                   ? () => onContactSelected!(contact)
//     //                   : null,
//     //               child: Column(
//     //                 children: [
//     //                   Container(
//     //                     decoration: BoxDecoration(
//     //                       color: AppColors.secondary.withOpacity(0.09),
//     //                       borderRadius: BorderRadius.circular(10.0),
//     //                     ),
//     //                     padding: const EdgeInsets.all(16.0),
//     //                     child: Row(
//     //                       children: [
//     //                         CircleAvatar(
//     //                           radius: 20.0,
//     //                           backgroundImage: contact.imageUrl.isNotEmpty
//     //                               ? NetworkImage(contact.imageUrl)
//     //                               : null, // No image if the URL is empty
//     //                           backgroundColor: Colors.transparent,
//     //                           child: contact.imageUrl.isEmpty
//     //                               ? const CircleAvatar(
//     //                                   radius: 20,
//     //                                   child: Icon(
//     //                                     Icons.person, // Use the desired icon
//     //                                     size:
//     //                                         20.0, // Adjust size to fit the avatar
//     //                                     color: Colors
//     //                                         .grey, // Customize the icon color if needed
//     //                                   ),
//     //                                 )
//     //                               : null, // No icon if the URL is not empty
//     //                         ),
//     //                         const SizedBox(width: 16.0),
//     //                         Column(
//     //                           crossAxisAlignment: CrossAxisAlignment.start,
//     //                           children: [
//     //                             Text(
//     //                               contact.name,
//     //                               style: const TextStyle(
//     //                                 fontSize: 14.0,
//     //                                 fontWeight: FontWeight.w700,
//     //                                 fontFamily: 'Montserrat',
//     //                                 color: AppColors.primary,
//     //                               ),
//     //                             ),
//     //                             Row(
//     //                               children: [
//     //                                 const Icon(Icons.phone,
//     //                                     size: 16.0, color: AppColors.primary),
//     //                                 const SizedBox(width: 8.0),
//     //                                 Text(
//     //                                   contact.phoneNumber,
//     //                                   style: const TextStyle(
//     //                                     fontSize: 12.0,
//     //                                     fontWeight: FontWeight.w400,
//     //                                     fontFamily: 'Montserrat',
//     //                                     color: AppColors.primary,
//     //                                   ),
//     //                                 ),
//     //                               ],
//     //                             ),
//     //                           ],
//     //                         ),
//     //                         const Spacer(),
//     //                         IconButtonWithMenu(
//     //                           phoneNumber: contact.phoneNumber,
//     //                           email: contact.email,
//     //                           contacts: contact,
//     //                           receiverId: contact.uid,
//     //                         ),
//     //                       ],
//     //                     ),
//     //                   ),
//     //                   10.ph,
//     //                 ],
//     //               ),
//     //             ),
//     //           );
//     //         },
//     //       );
//     //     },
//     //   ),
//     // );

//   }

// }

// class ContactListview extends StatelessWidget {
//  final void Function(Contact contact)? onContactSelected;

//   const ContactListview({super.key, this.onContactSelected});

//   @override
//   Widget build(BuildContext context) {
//     final String? userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) {
//       return const Center(child: Text("User not logged in."));
//     }

//     return FutureBuilder<String>(
//       future: _determineUserCollection(userId),
//       builder: (context, collectionSnapshot) {
//         if (collectionSnapshot.connectionState == ConnectionState.waiting) {
//           return _buildShimmerLoading();
//         }

//         if (collectionSnapshot.hasError || !collectionSnapshot.hasData) {
//           return const Center(child: Text("Failed to determine user collection."));
//         }

//         final collectionName = collectionSnapshot.data!;
//         final contactsRef = FirebaseFirestore.instance
//             .collection(collectionName)
//             .doc(userId)
//             .collection('contacts');

//         return StreamBuilder<QuerySnapshot>(
//           stream: contactsRef.snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return _buildShimmerLoading(shimmerCount: snapshot.data?.docs.length ?? 2);
//             }

//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Center(child: Text("No contacts available."));
//             }

//             final contacts = snapshot.data!.docs
//                 .map((doc) => Contact.fromFirestore(doc))
//                 .toList();

//             return ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: contacts.length,
//               itemBuilder: (context, index) => _buildContactItem(contacts[index], contactsRef, context),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<String> _determineUserCollection(String userId) async {
//     final collections = ['trackingUsers', 'trackUsers'];
//     for (final collection in collections) {
//       try {
//         final docSnapshot = await FirebaseFirestore.instance
//             .collection(collection)
//             .doc(userId)
//             .get();
//         if (docSnapshot.exists) return collection;
//       } catch (e) {
//         debugPrint("Error checking collection $collection: $e");
//       }
//     }
//     throw Exception('User not found in any collection');
//   }

//   Widget _buildShimmerLoading({int shimmerCount = 2}) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: shimmerCount,
//       itemBuilder: (context, index) => _buildShimmerItem(),
//     );
//   }

//   Widget _buildShimmerItem() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//         padding: const EdgeInsets.all(16.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 20.0,
//               backgroundColor: Colors.grey.shade400,
//             ),
//             const SizedBox(width: 16.0),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: 14.0,
//                     color: Colors.grey.shade400,
//                   ),
//                   const SizedBox(height: 8.0),
//                   Container(
//                     width: 100.0,
//                     height: 12.0,
//                     color: Colors.grey.shade400,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildContactItem(Contact contact, CollectionReference contactsRef, BuildContext context) {
//     return Dismissible(
//       key: Key(contact.id),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         alignment: Alignment.centerRight,
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         color: Colors.red,
//         child: const Icon(Icons.delete, color: Colors.white),
//       ),
//       confirmDismiss: (_) => _showDeleteConfirmationDialog(context),
//       onDismissed: (_) async => await contactsRef.doc(contact.id).delete(),
//       child: _buildContactDetails(contact),
//     );
//   }

//   Widget _buildContactDetails(Contact contact) {
//     return Container(
//       decoration: BoxDecoration(
//         color: AppColors.secondary.withOpacity(0.09),
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           _buildAvatar(contact),
//           const SizedBox(width: 16.0),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   contact.name,
//                   style: const TextStyle(
//                     fontSize: 14.0,
//                     fontWeight: FontWeight.w700,
//                     fontFamily: 'Montserrat',
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     const Icon(Icons.phone, size: 16.0, color: AppColors.primary),
//                     const SizedBox(width: 8.0),
//                     Text(
//                       contact.phoneNumber,
//                       style: const TextStyle(
//                         fontSize: 12.0,
//                         fontWeight: FontWeight.w400,
//                         fontFamily: 'Montserrat',
//                         color: AppColors.primary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           IconButtonWithMenu(
//             phoneNumber: contact.phoneNumber,
//             email: contact.email,
//             contacts: contact,
//             receiverId: contact.uid,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAvatar(Contact contact) {
//     return CircleAvatar(
//       radius: 20.0,
//       backgroundImage: contact.imageUrl.isNotEmpty ? NetworkImage(contact.imageUrl) : null,
//       backgroundColor: Colors.transparent,
//       child: contact.imageUrl.isEmpty
//           ? const CircleAvatar(
//               radius: 20,
//               child: Icon(Icons.person, size: 20.0, color: Colors.grey),
//             )
//           : null,
//     );
//   }

//   Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
//     return await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Are you sure?"),
//           content: const Text("Do you really want to delete this contact?"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: const Text("No"),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               child: const Text("Yes"),
//             ),
//           ],
//         );
//       },
//     ) ?? false;
//   }
// }
class ContactListview extends StatelessWidget {
  final void Function(Contact contact)? onContactSelected;

  const ContactListview({super.key, this.onContactSelected});

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    var userRef;
    if (userId == null) {
      return const Center(child: Text("User not logged in."));
    }

    return FutureBuilder<String>(
      future: _determineUserCollection(userId),
      builder: (context, collectionSnapshot) {
        if (collectionSnapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }

        if (collectionSnapshot.hasError || !collectionSnapshot.hasData) {
          return const Center(
              child: Text("Failed to determine user collection."));
        }

        final collectionName = collectionSnapshot.data!;
        final contactsRef = FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userId)
            .collection('contacts');

        return StreamBuilder<QuerySnapshot>(
          stream: contactsRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildShimmerLoading(
                  shimmerCount: snapshot.data?.docs.length ?? 2);
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No contacts available."));
            }

            final contacts = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contactDoc = contacts[index];
                userRef = contactDoc['reference'];

                DocumentReference userDocumentRef;

                // If userRef is a String, split it into collection and document ID
                if (userRef is String && userRef.contains('/')) {
                  // Split the userRef string by '/'
                  final segments = userRef.split('/');

                  if (segments.length == 2) {
                    // Construct a valid DocumentReference from the collection and document ID
                    final collection = segments[0];
                    final documentId = segments[1];

                    // Create the reference
                    userDocumentRef = FirebaseFirestore.instance
                        .collection(collection)
                        .doc(documentId);
                  } else {
                    return const Center(
                        child: Text("Invalid user reference format."));
                  }
                } else {
                  return const Center(child: Text("Invalid user reference."));
                }

                return FutureBuilder<DocumentSnapshot>(
                  future: userDocumentRef.get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return _buildShimmerItem();
                    }

                    if (userSnapshot.hasError) {
                      debugPrint(
                          'Error fetching user data: ${userSnapshot.error}');
                      return const Center(
                          child: Text("Error fetching user data."));
                    }

                    if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      debugPrint(
                          "User data not found for: ${userDocumentRef.id}");
                      return const Center(child: Text("User data not found."));
                    }

                    final userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;
                    print("userid${userDocumentRef.id}");
                    final contact = Contact(
                      id: contactDoc.id,
                      name: userData['name'] ?? 'No Name',
                      phoneNumber: userData['phonenumber'] ?? 'No Phone',
                      email: userData['email'] ?? 'No Email',
                      imageUrl: userData['imageUrl'] ?? '',
                      uid: userDocumentRef.id,
                      deviceToken: userData['deviceToken'] ?? '',
                      reference: userRef,
                    );

                    return InkWell(
                      onTap: () {
                        if (onContactSelected != null) {
                          onContactSelected!(contact);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildContactItem(contact, contactsRef, context),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<String> _determineUserCollection(String userId) async {
    final collections = ['trackingUsers', 'trackUsers'];
    for (final collection in collections) {
      try {
        final docSnapshot = await FirebaseFirestore.instance
            .collection(collection)
            .doc(userId)
            .get();
        if (docSnapshot.exists) return collection;
      } catch (e) {
        debugPrint("Error checking collection $collection: $e");
      }
    }
    throw Exception('User not found in any collection');
  }

  Widget _buildShimmerLoading({int shimmerCount = 2}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: shimmerCount,
      itemBuilder: (context, index) => _buildShimmerItem(),
    );
  }

  Widget _buildShimmerItem() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.grey.shade400,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 14.0,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: 100.0,
                    height: 12.0,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(
      Contact contact, CollectionReference contactsRef, BuildContext context) {
    return Dismissible(
      key: Key(contact.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) => _showDeleteConfirmationDialog(context),
      onDismissed: (_) async => await contactsRef.doc(contact.id).delete(),
      child: _buildContactDetails(contact),
    );
  }

  Widget _buildContactDetails(Contact contact) {
    return InkWell(
      // onTap: onContactSelected,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.secondary.withOpacity(0.09),
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            _buildAvatar(contact),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Montserrat',
                      color: AppColors.primary,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.phone,
                          size: 12.0, color: AppColors.primary),
                      const SizedBox(width: 2),
                      Text(
                        contact.phoneNumber,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Montserrat',
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButtonWithMenu(
              phoneNumber: contact.phoneNumber,
              email: contact.email,
              contacts: contact,
              receiverId: contact.uid,
              deviceToken: contact.deviceToken,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Contact contact) {
    return CircleAvatar(
      radius: 20.0,
      backgroundImage:
          contact.imageUrl.isNotEmpty ? NetworkImage(contact.imageUrl) : null,
      backgroundColor: Colors.transparent,
      child: contact.imageUrl.isEmpty
          ? const CircleAvatar(
              radius: 20,
              child: Icon(Icons.person, size: 20.0, color: Colors.grey),
            )
          : null,
    );
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Are you sure?"),
              content: const Text("Do you really want to delete this contact?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

Future<DocumentSnapshot<Object?>> _fetchUserFromEitherCollection(
    String userId) async {
  try {
    // First, check in the 'trackUsers' collection
    final trackUsersDoc = await FirebaseFirestore.instance
        .collection('trackUsers')
        .doc(userId)
        .get();
    if (trackUsersDoc.exists) {
      return trackUsersDoc;
    }

    // If not found, check in the 'trackingUsers' collection
    final trackingUsersDoc = await FirebaseFirestore.instance
        .collection('trackingUsers')
        .doc(userId)
        .get();
    if (trackingUsersDoc.exists) {
      return trackingUsersDoc;
    }

    // If not found in both collections, return an empty DocumentSnapshot (null data)
    return Future.value(null);
  } catch (e) {
    debugPrint('Error fetching user from either collection: $e');
    rethrow; // Re-throw to let the FutureBuilder handle the error
  }
}

class IconButtonWithMenu extends StatelessWidget {
  final GlobalKey _key = GlobalKey();
  final String phoneNumber;
  final String email;
  final Contact contacts;
  final String receiverId;
  final String deviceToken;

  IconButtonWithMenu({
    super.key,
    required this.phoneNumber,
    required this.email,
    required this.contacts,
    required this.receiverId,
    required this.deviceToken,
  });

  // final String? userId = FirebaseAuth.instance.currentUser?.uid;

  // Future<String> _determineUserCollection(String userId) async {
  //   final collections = ['trackingUsers', 'trackUsers'];
  //   for (final collection in collections) {
  //     try {
  //       final docSnapshot = await FirebaseFirestore.instance
  //           .collection(collection)
  //           .doc(userId)
  //           .get();
  //       if (docSnapshot.exists) return collection;
  //     } catch (e) {
  //       debugPrint("Error checking collection $collection: $e");
  //     }
  //   }
  //   throw Exception('User not found in any collection');
  // }

  Future<Position?> _getLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied.');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied.');
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      return position;
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  Future<void> _sendEmailWithLocation(Position position) async {
    String mapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
    String body = 'Your relative is in trouble.\nCurrent Location: $mapsUrl';

    // Encode the query parameters
    String encodedBody = Uri.encodeComponent(body);

    await launchUrl(
      Uri(
        scheme: 'mailto',
        path: email,
        query: 'subject=Emergency&body=$encodedBody',
      ),
    );
  }

  void _onEmailOptionSelected(BuildContext context) async {
    Position? position = await _getLocation();
    if (position != null) {
      await _sendEmailWithLocation(position);
    } else {
      print('Could not determine the location.');
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return early.
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, return early.
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, return early.
      return null;
    }

    // When we reach here, permissions are granted, and we can fetch the location.
    return await Geolocator.getCurrentPosition();
  }

  Future<Position?> _onLocationIconTapped() async {
    Position? position = await _getCurrentLocation();
    if (position != null) {
      print('Current position: ${position.latitude}, ${position.longitude}');
      print(position);
      return position;

      // You can handle the location data here, such as updating the UI or sending it to a server.
    } else {
      print('Failed to get current location.');
    }
    return null;
  }

  // void _showDialog(BuildContext context) {
  //   final RenderBox renderBox =
  //       _key.currentContext!.findRenderObject() as RenderBox;
  //   final Offset offset = renderBox.localToGlobal(Offset.zero);

  //   showMenu(
  //     context: context,
  //     position: RelativeRect.fromLTRB(
  //       offset.dx,
  //       offset.dy + renderBox.size.height,
  //       offset.dx + 1,
  //       offset.dy + 1,
  //     ),
  //     items: <PopupMenuEntry>[
  //       PopupMenuItem(
  //         child: Consumer<UserChoiceProvider>(
  //           builder: (context, userChoiceProvider, child) {
  //             if (userChoiceProvider.userChoice == 'Track') {
  //               return _buildOption(
  //                 context,
  //                 "Email",
  //                 Provider.of<OptionProvider>(context, listen: false)
  //                             .selectedOption ==
  //                         "Email"
  //                     ? AppColors.secondary
  //                     : AppColors.secondary.withOpacity(0.1),
  //                 Provider.of<OptionProvider>(context, listen: false)
  //                             .selectedOption ==
  //                         "Email"
  //                     ? Colors.white
  //                     : AppColors.primary,
  //                 () async {
  //                   _showLoadingIndicator(context);
  //                   _onEmailOptionSelected(context);
  //                   Navigator.pop(context);
  //                 },
  //               );
  //             }
  //             return const SizedBox(); // Return an empty widget if the role is not 'Track'
  //           },
  //         ),
  //       ),

  //       // PopupMenuItem(
  //       //   child: _buildOption(
  //       //     context,
  //       //     "Email",
  //       //     Provider.of<OptionProvider>(context, listen: false)
  //       //                 .selectedOption ==
  //       //             "Email"
  //       //         ? AppColors.secondary
  //       //         : AppColors.secondary.withOpacity(0.1),
  //       //     Provider.of<OptionProvider>(context, listen: false)
  //       //                 .selectedOption ==
  //       //             "Email"
  //       //         ? Colors.white
  //       //         : AppColors.primary,
  //       //     () async {
  //       //       _showLoadingIndicator(context);
  //       //       _onEmailOptionSelected(context);
  //       //       Navigator.pop(context);
  //       //     },
  //       //   ),
  //       // ),
  //       PopupMenuItem(
  //         child: _buildOption(
  //           context,
  //           "Phone calls",
  //           Provider.of<OptionProvider>(context, listen: false)
  //                       .selectedOption ==
  //                   "Phone calls"
  //               ? AppColors.secondary
  //               : AppColors.secondary.withOpacity(0.1),
  //           Provider.of<OptionProvider>(context, listen: false)
  //                       .selectedOption ==
  //                   "Phone calls"
  //               ? Colors.white
  //               : AppColors.primary,
  //           () async {
  //             Provider.of<OptionProvider>(context, listen: false)
  //                 .setSelectedOption("Phone calls");

  //             await launchUrl(
  //               Uri(
  //                 scheme: 'tel',
  //                 path: phoneNumber,
  //               ),
  //             );

  //             Navigator.pop(context);
  //           },
  //         ),
  //       ),
  //       PopupMenuItem(
  //         child: _buildOption(
  //           context,
  //           "App notifications",
  //           Provider.of<OptionProvider>(context, listen: false)
  //                       .selectedOption ==
  //                   "App notifications"
  //               ? AppColors.secondary
  //               : AppColors.secondary.withOpacity(0.1),
  //           Provider.of<OptionProvider>(context, listen: false)
  //                       .selectedOption ==
  //                   "App notifications"
  //               ? Colors.white
  //               : AppColors.primary,
  //           () async {
  //             Navigator.pop(context);
  //             _showLoadingIndicator(context);
  //             try {
  //               Position? position = await _onLocationIconTapped();
  //               if (position != null) {
  //                 Provider.of<OptionProvider>(context, listen: false)
  //                     .setSelectedOption("App notifications");

  //                 // Fetch the device token from the contact
  //                 String? deviceToken =
  //                     await getDeviceTokenFromContact(contacts);

  //                 if (deviceToken != null) {
  //                   User? currentUser = FirebaseAuth.instance.currentUser;
  //                   if (currentUser != null) {
  //                     String senderId = currentUser.uid;

  //                     // Check the user's role and set the notification body accordingly
  //                     DocumentSnapshot trackingUserDoc = await FirebaseFirestore
  //                         .instance
  //                         .collection('trackingUsers')
  //                         .doc(senderId)
  //                         .get();

  //                     String body;

  //                     if (trackingUserDoc.exists) {
  //                       print("receiverid$receiverId");
  //                       // Notification body for TrackingUser
  //                       await PushNotification.sendNotificationToUser(
  //                           deviceToken,
  //                           context,
  //                           senderId,
  //                           receiverId,
  //                           "Notification",
  //                           "I want to access your location");
  //                     } else {
  //                       // Check if the user is in the 'TrackedUser' collection
  //                       DocumentSnapshot trackedUserDoc =
  //                           await FirebaseFirestore.instance
  //                               .collection('trackUsers')
  //                               .doc(senderId)
  //                               .get();

  //                       if (trackedUserDoc.exists) {
  //                         print("receiveridtracked$receiverId");
  //                         // Notification body for TrackedUser
  //                         String mapsUrl =
  //                             'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
  //                         await PushNotification.sendNotificationToSelectedRole(
  //                           deviceToken,
  //                           context,
  //                           senderId,
  //                           receiverId,
  //                           position.latitude,
  //                           position.longitude,
  //                           "Notification",
  //                           'My Location $mapsUrl',
  //                         );
  //                       } else {
  //                         throw Exception('User role is unknown.');
  //                       }
  //                     }

  //                     showTopSnackBar(
  //                       context,
  //                       'Notification Sent',
  //                       Colors.green,
  //                     );
  //                   } else {
  //                     throw Exception('Failed to retrieve current user ID.');
  //                   }
  //                 } else {
  //                   throw Exception('Failed to retrieve device token.');
  //                 }
  //               } else {
  //                 throw Exception('Position is null.');
  //               }
  //             } catch (e) {
  //               // Show a SnackBar with the exception message
  //               showTopSnackBar(
  //                 context,
  //                 'Error: ${e.toString()}',
  //                 Colors.red,
  //               );
  //             } finally {
  //               Navigator.pop(context);
  //             }
  //           },
  //         ),
  //       ),

  //       // PopupMenuItem(
  //       //   child: _buildOption(
  //       //     context,
  //       //     "App notifications",
  //       //     Provider.of<OptionProvider>(context, listen: false)
  //       //                 .selectedOption ==
  //       //             "App notifications"
  //       //         ? AppColors.secondary
  //       //         : AppColors.secondary.withOpacity(0.1),
  //       //     Provider.of<OptionProvider>(context, listen: false)
  //       //                 .selectedOption ==
  //       //             "App notifications"
  //       //         ? Colors.white
  //       //         : AppColors.primary,
  //       //     () async {
  //       //       _showLoadingIndicator(context);
  //       //       Position? position = await _onLocationIconTapped();
  //       //       if (position != null) {
  //       //         Provider.of<OptionProvider>(context, listen: false)
  //       //             .setSelectedOption("App notifications");

  //       //         // Fetch the device token from the contact
  //       //         String? deviceToken = await getDeviceTokenFromContact(contacts);

  //       //         if (deviceToken != null) {
  //       //           User? currentUser = FirebaseAuth.instance.currentUser;
  //       //           if (currentUser != null) {
  //       //             String senderId = currentUser.uid;

  //       //             // Check the user's role and set the notification body accordingly
  //       //             DocumentSnapshot trackingUserDoc = await FirebaseFirestore
  //       //                 .instance
  //       //                 .collection('trackingUsers')
  //       //                 .doc(senderId)
  //       //                 .get();

  //       //             String body;

  //       //             if (trackingUserDoc.exists) {
  //       //               print("receiverid$receiverId");
  //       //               // Notification body for TrackingUser
  //       //               String senderId = currentUser.uid;
  //       //               await PushNotification.sendNotificationToUser(
  //       //                   deviceToken,
  //       //                   context,
  //       //                   senderId,
  //       //                   receiverId,
  //       //                   "Notification",
  //       //                   "I want to access your location");
  //       //             } else {
  //       //               // Check if the user is in the 'TrackedUser' collection
  //       //               DocumentSnapshot trackedUserDoc = await FirebaseFirestore
  //       //                   .instance
  //       //                   .collection('trackUsers')
  //       //                   .doc(senderId)
  //       //                   .get();

  //       //               if (trackedUserDoc.exists) {
  //       //                 print("receiveridtracked$receiverId");
  //       //                 // Notification body for TrackedUser
  //       //                 String senderId = currentUser.uid;
  //       //                 String mapsUrl =
  //       //                     'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
  //       //                 String body = mapsUrl;
  //       //                 await PushNotification.sendNotificationToSelectedRole(
  //       //                   deviceToken,
  //       //                   context,
  //       //                   senderId,
  //       //                   receiverId,
  //       //                   position.latitude,
  //       //                   position.longitude,
  //       //                   "Notification",
  //       //                   body,
  //       //                 );
  //       //               } else {
  //       //                 print('User role is unknown.');
  //       //                 return;
  //       //               }
  //       //             }
  //       //             Navigator.of(context).pop();
  //       //             // ScaffoldMessenger.of(context).showSnackBar(
  //       //             //   const SnackBar(
  //       //             //     content: Text('Notification sent'),
  //       //             //   ),
  //       //             // );

  //       //             showTopSnackBar(
  //       //               context,
  //       //               'Notification Sent',
  //       //               Colors.green,
  //       //             );
  //       //           } else {
  //       //             throw Exception('Failed to retrieve current user ID.');
  //       //           }
  //       //         } else {
  //       //           throw Exception('Failed to retrieve device token.');
  //       //         }
  //       //       }

  //       //       Navigator.pop(context);
  //       //     },
  //       //   ),
  //       // ),
  //     ],
  //   );
  // }

  void _showDialog(BuildContext context) {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    // Define a list to hold PopupMenuEntry items
    final List<PopupMenuEntry> popupMenuItems = [];

    // Add the "Email" option only if the user role is 'Track'
    final userChoiceProvider =
        Provider.of<UserChoiceProvider>(context, listen: false);
    if (userChoiceProvider.userChoice == 'Track') {
      popupMenuItems.add(
        PopupMenuItem(
          child: _buildOption(
            context,
            "Email",
            Provider.of<OptionProvider>(context, listen: false)
                        .selectedOption ==
                    "Email"
                ? AppColors.secondary
                : AppColors.secondary.withOpacity(0.1),
            Provider.of<OptionProvider>(context, listen: false)
                        .selectedOption ==
                    "Email"
                ? Colors.white
                : AppColors.primary,
            () async {
              _showLoadingIndicator(context);
              _onEmailOptionSelected(context);
              Navigator.pop(context);
            },
          ),
        ),
      );
    }

    // Add "Phone calls" option
    popupMenuItems.add(
      PopupMenuItem(
        child: _buildOption(
          context,
          "Phone calls",
          Provider.of<OptionProvider>(context, listen: false).selectedOption ==
                  "Phone calls"
              ? AppColors.secondary
              : AppColors.secondary.withOpacity(0.1),
          Provider.of<OptionProvider>(context, listen: false).selectedOption ==
                  "Phone calls"
              ? Colors.white
              : AppColors.primary,
          () async {
            Provider.of<OptionProvider>(context, listen: false)
                .setSelectedOption("Phone calls");

            await launchUrl(
              Uri(
                scheme: 'tel',
                path: phoneNumber,
              ),
            );

            Navigator.pop(context);
          },
        ),
      ),
    );

    // Add "App notifications" option
    popupMenuItems.add(
      PopupMenuItem(
        child: _buildOption(
          context,
          "App notifications",
          Provider.of<OptionProvider>(context, listen: false).selectedOption ==
                  "App notifications"
              ? AppColors.secondary
              : AppColors.secondary.withOpacity(0.1),
          Provider.of<OptionProvider>(context, listen: false).selectedOption ==
                  "App notifications"
              ? Colors.white
              : AppColors.primary,
          () async {
            Navigator.pop(context);
            _showLoadingIndicator(context);
            try {
              Position? position = await _onLocationIconTapped();
              if (position != null) {
                Provider.of<OptionProvider>(context, listen: false)
                    .setSelectedOption("App notifications");

                // String? deviceToken = await getDeviceTokenFromContact(contacts);

                User? currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  String senderId = currentUser.uid;

                  DocumentSnapshot trackingUserDoc = await FirebaseFirestore
                      .instance
                      .collection('trackingUsers')
                      .doc(senderId)
                      .get();

                  if (trackingUserDoc.exists) {
                    await PushNotification.sendNotificationToUser(
                        deviceToken,
                        context,
                        senderId,
                        receiverId,
                        "Notification",
                        "I want to access your location");
                  } else {
                    DocumentSnapshot trackedUserDoc = await FirebaseFirestore
                        .instance
                        .collection('trackUsers')
                        .doc(senderId)
                        .get();

                    if (trackedUserDoc.exists) {
                      String mapsUrl =
                          'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
                      await PushNotification.sendNotificationToSelectedRole(
                        deviceToken,
                        context,
                        senderId,
                        receiverId,
                        position.latitude,
                        position.longitude,
                        "Notification",
                        'My Location $mapsUrl',
                      );
                    } else {
                      throw Exception('User role is unknown.');
                    }
                  }

                  showTopSnackBar(
                    context,
                    'Notification Sent',
                    Colors.green,
                  );
                } else {
                  throw Exception('Failed to retrieve current user ID.');
                }
              } else {
                throw Exception('Position is null.');
              }
            } catch (e) {
              showTopSnackBar(
                context,
                'Error: ${e.toString()}',
                Colors.red,
              );
            } finally {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );

    // Show the menu with dynamically added items
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + 1,
        offset.dy + 1,
      ),
      items: popupMenuItems, // Use the dynamically created items list
    );
  }

  Widget _buildOption(BuildContext context, String title, Color bgColor,
      Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: bgColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final optionProvider = context.watch<OptionProvider>();

    return IconButton(
      key: _key,
      onPressed: () {
        _showDialog(context);
      },
      icon: const Icon(
        Icons.more_vert,
        color: AppColors.primary,
      ),
    );
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
