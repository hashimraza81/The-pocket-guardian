import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String imageUrl;
  final String email;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.imageUrl,
    required this.email,
  });

  factory Contact.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Contact(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phonenumber'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
