import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gentech/model/contact_model.dart';

Future<String?> getDeviceTokenFromContact(Contact contacts) async {
  try {
    print('Reference: ${contacts.reference}'); // Debugging log

    // Fetch the user's document using the reference stored in the contact
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .doc(contacts.reference!) // 'refere  nce' field in the Contact document
        .get();

    if (userDoc.exists) {
      // Return the deviceToken field from the user's document
      return userDoc.data() != null
          ? (userDoc.data() as Map<String, dynamic>)['deviceToken'] as String?
          : null;
    } else {
      print('User document does not exist');
      return null;
    }
  } catch (error) {
    print('Error fetching device token: $error');
    return null;
  }
}
