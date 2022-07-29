class UserModel {
  UserModel({
    required this.uid,
    // required this.name,
    required this.email,
    this.username,
    this.photoURL,
  });

  //* Convert the Json object to a UserModel object
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'] as String,
        email: json['email'] as String,
        username: json['displayName'] as String,
        photoURL: json['photoURL'] as String?,
      );

  final String email;
  final String? photoURL;
  final String uid;
  // final String name;
  final String? username;

  //* Convert the UserModel to a Json object
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'username': username,
        'photoURL': photoURL,
      };
}
