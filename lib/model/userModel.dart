class UserModel {
  String uid;
  String email;
  String name;
  String phonenumber;
  String? imageUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phonenumber,
    this.imageUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      phonenumber: data['phonenumber'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phonenumber': phonenumber,
      'imageUrl': imageUrl,
    };
  }
}
