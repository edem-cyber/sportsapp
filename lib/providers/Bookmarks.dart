// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:sportsapp/models/Post.dart';
// import 'package:sportsapp/providers/AuthProvider.dart';
// import 'package:sportsapp/services/database_service.dart';

// class BookmarkModel extends ChangeNotifier {
//   List<Article> articles = [];
//   // List<Article> get articles => _articles;
//   //initialise firestore
//   late final DatabaseService _databaseService;
//   // DatabaseService get databaseService => _databaseService;
//   late final AuthProvider _authProvider;
//   // AuthProvider get authProvider => _authProvider;
//   //authprovider constructor

//   BookmarkModel() {
//     _databaseService = DatabaseService();
//     _authProvider = AuthProvider();
//     // getBookmarks(uid: _authProvider.user!.uid);
//   }

//   void addToBookmark(Article article) {
//     articles.add(article);
//     notifyListeners();
//   }

//   void removeFromBookmark(Article article) {
//     articles.remove(article);
//     notifyListeners();
//   }

//   // void getBookmarks({required String uid}) async {
//   //   QuerySnapshot snapshot = await _databaseService.getCollection(
//   //       uid: uid, collectionName: collectionName);
//   //   // articles = snapshot.docs
//   //   //     .map((doc) => Article.fromMap(doc.data() as Map<String, dynamic>))
//   //   //     .toList();
//   //   notifyListeners();
//   // }
// }
