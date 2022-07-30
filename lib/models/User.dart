// class UserModel {
//   final String uid;
//   final String email;
//   // final String name;
//   final String username;
//   final String? photoURL;

//   UserModel({
//     required this.uid,
//     // required this.name,
//     required this.email,
//     required this.username,
//     this.photoURL,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       uid: json['uid'] as String,
//       email: json['email'] as String,
//       // name: json['name'] as String,
//       username: json['displayName'] as String,
//       photoURL: json['photoURL'] as String,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'uid': uid,
//       'email': email,
//       // 'name': name,
//       'displayName': username,
//       'photoURL': photoURL,
//     };
//   }
// }
