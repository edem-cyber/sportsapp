class UserModel {
  final String uid;
  final String email;
  // final String name;
  final String username;
  final String? avatar;

  UserModel({
    required this.uid,
    // required this.name,
    required this.email,
    required this.username,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      // name: json['name'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      // 'name': name,
      'username': username,
      'avatar': avatar,
    };
  }
}
