import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  final String id;
  final String uid;
  final String name;
  final String phoneNumber;
  final String imageUrl;
  final String email;
  final String deviceToken;
  final String reference;

  Contact({
    required this.id,
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.imageUrl,
    required this.email,
    required this.deviceToken,
    required this.reference,
  });

  factory Contact.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Debug output to check which fields might be null
//     // print('Document data: $data');
//     // print('uid: ${data['uid']}');
//     // print('name: ${data['name']}');
//     // print('phoneNumber: ${data['phonenumber']}');
//     // print('imageUrl: ${data['imageUrl']}');
//     // print('email: ${data['email']}');
//     // print('deviceToken: ${data['deviceToken']}');
//     // print('reference: ${data['reference']}');

    return Contact(
      id: doc.id,
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      phoneNumber: data['phonenumber'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      email: data['email'] ?? '',
      deviceToken: data['deviceToken'] ?? '',
      reference: data['reference'] ?? '',
    );
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      uid: json['uid'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      imageUrl: json['imageUrl'] as String,
      email: json['email'] as String,
      deviceToken: json['deviceToken'] as String,
      reference: json['reference'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'email': email,
      'deviceToken': deviceToken,
      'reference': reference,
    };
  }
}
