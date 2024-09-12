class UserModel {
  String uid;
  String email;
  String name;
  String phonenumber;
  String? imageUrl;
  bool? subscribed;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phonenumber,
    this.imageUrl,
    this.subscribed,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
        uid: data['uid'],
        email: data['email'],
        name: data['name'],
        phonenumber: data['phonenumber'],
        imageUrl: data['imageUrl'],
        subscribed: data['subscribed']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phonenumber': phonenumber,
      'imageUrl': imageUrl,
      'subcribed': subscribed,
    };
  }
}
