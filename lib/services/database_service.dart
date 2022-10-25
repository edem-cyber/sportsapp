// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:sportsapp/models/ChatMessageModel.dart';
import 'package:sportsapp/models/Post.dart';

// Models

const String userCollection = 'Users';
const String postDoc = 'liked_posts';
const String chatCollection = 'Chats';
const String messagesCollection = 'Messages';

class DatabaseService {
  DatabaseService();
  final FirebaseFirestore _dataBase = FirebaseFirestore.instance;
  // var postsRef = FirebaseFirestore.instance.collection(userCollection);

  Future<bool> isDuplicateUniqueName({String? username}) async {
    QuerySnapshot query = await _dataBase
        .collection(userCollection)
        .where('username', isEqualTo: username)
        .get();
    return query.docs.isNotEmpty;
  }

  Future addUserInfoToDB(
      {required String uid, required Map<String, dynamic> userInfoMap}) {
    return _dataBase.collection(userCollection).doc(uid).set(userInfoMap);
  }

  //firestore function to add to likes

  //Update User
  Future<void> updateUser(
      {required String uid, required Map<String, dynamic> userInfoMap}) async {
    try {
      // * Going to the collections (User) the to the user uid and overrides the values of the fields
      await _dataBase.collection(userCollection).doc(uid).update(userInfoMap);
    } catch (error) {
      debugPrint('$error');
    }
  }

  Future getUser({required String uid}) async {
    return await _dataBase.collection(userCollection).doc(uid).get();
  }

//* Getting the chats from the users
  // Stream<QuerySnapshot> getChatsForsUser(String uid) {
  //   return _dataBase
  //       .collection(chatCollection)
  //       .where(
  //         'members',
  //         arrayContains: uid,
  //       )
  //       .snapshots();
  // }

  //* Update to the last chat sent
  Future<QuerySnapshot> getLastMessageFroChat({required String chatID}) {
    return _dataBase
        .collection(chatCollection)
        .doc(chatID)
        .collection(messagesCollection)
        .orderBy(
          'sent_time',
          descending: true,
        )
        .limit(1)
        .get();
  }

  // Stream<QuerySnapshot> streamMessagesForChatPage(String chatId) {
  //   return _dataBase
  //       .collection(chatCollection)
  //       .doc(chatId)
  //       .collection(messagesCollection)
  //       .orderBy('sent_time', descending: false)
  //       .snapshots();
  // }

  // // * Add messages to the firestore databse
  // Future<void> addMessagesToChat(String chatId, ChatMessage message) async {
  //   try {
  //     await _dataBase
  //         .collection(chatCollection)
  //         .doc(chatId)
  //         .collection(messagesCollection)
  //         .add(
  //           message.toJson(),
  //         );
  //   } catch (error) {
  //     debugPrint('$error');
  //   }
  // }

  // Future<void> updateChatData(String chatId, Map<String, dynamic> data) async {
  //   try {
  //     await _dataBase.collection(chatCollection).doc(chatId).update(data);
  //   } catch (error) {
  //     debugPrint('$error');
  //   }
  // }

//   // *Delete chat
//   Future<void> deleteChat(String chatId) async {
//     try {
//       await _dataBase.collection(chatCollection).doc(chatId).delete();
//     } catch (error) {
//       debugPrint('$error');
//     }
//   }

// // * Select and Create chat
//   Future<DocumentReference?> createChat(Map<String, dynamic> data) async {
//     try {
//       final chat = await _dataBase.collection(chatCollection).add(data);
//       return chat;
//     } catch (error) {
//       debugPrint('$error');
//     }
//     return null;
//   }

//* Update time
  Future<void> updateUserLastSeenTime({required String uid}) async {
    try {
      await _dataBase.collection(userCollection).doc(uid).update(
        {
          'last_active': DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  Stream<List> getPosts(
      {required String uid, required String postType, required int limit}) {
    return _dataBase
        .collection('Posts')
        .where('uid', isEqualTo: uid)
        .where('post_type', isEqualTo: postType)
        .orderBy('created_at', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Future<bool> setBookmarks(
  //     {required String sourceName,
  //     required String imageUrl,
  //     required String title,
  //     required String description,
  //     required String url,
  //     required String author,
  //     required String publishDate,
  //     required String uid}) async {
  //   // FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   try {
  //     await _dataBase
  //         .collection(userCollection)
  //         .doc(uid)
  //         .collection(postDoc)
  //         .doc(title)
  //         .set({
  //       "sourceName": sourceName,
  //       "imageUrl": imageUrl,
  //       "title": title,
  //       "description": description,
  //       "url": url,
  //       "author": author,
  //       "publishDate": publishDate,
  //     });
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  // Future<bool> likePost(String uid, String postUrl) async {
  //   try {
  //     await _dataBase
  //         .collection(userCollection)
  //         .doc(uid)
  //         .collection(postDoc)
  //         .doc(postUrl)
  //         .set({
  //       "postUrl": postUrl,
  //     });
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  //boolean function to check if the user is already in the database
  // Future<bool> isUserInDB(String uid) async {
  //   QuerySnapshot query = await _dataBase
  //       .collection(userCollection)
  //       .where('uid', isEqualTo: uid)
  //       .get();
  //   return query.docs.length > 0;

  Future<List<String>> getLikedPostsArray({required String uid}) async {
    List<String> likeList = [];

    await _dataBase.collection(userCollection).doc(uid).get().then((value) {
      likeList = List.from(value.data()![postDoc]);
    });

    debugPrint('LIKELIST: $likeList');
    return likeList;
  }

  Future<bool> isPostInLikedArray(
      {required String uid, required Article article}) async {
    List<String> likeList = await getLikedPostsArray(uid: uid);
    var isLiked = likeList.contains(article.articleUrl);
    return isLiked;
  }

  likePost({required String uid, required Article article}) async {
    // var isLiked = isPostLiked(uid: uid, article: article).then(
    //   (value) {
    //     return value;
    //   },
    // );

    List<String> likeList = await getLikedPostsArray(uid: uid);

    //loop through getLikedPostsArray and compare the article url to the list
    getLikedPostsArray(uid: uid).then(
      (value) {
        //if the article url is in the list, remove it
        if (value.contains(article.articleUrl)) {
          //else if the article url is not in the list, add it
          value.add(article.articleUrl!);
          _dataBase.collection(userCollection).doc(uid).update({
            postDoc: value,
          });
        }
      },

      //return .exists to check if the user is in the database
      // return query.docs[0].exists;
    );

    print(likeList.contains(article.articleUrl));

    return likeList.contains(article.articleUrl);

    // await _dataBase
    //     .collection(userCollection)
    //     .doc(uid)
    //     .update(
    //       {
    //         postDoc: FieldValue.arrayUnion(
    //           [
    //             article.articleUrl.toString(),
    //           ],
    //         )
    //       },
    //     )
    //     .then((value) => print("Liked Post Added"))
    //     .catchError(
    //       (error) => print("Failed to add liked post: $error"),
    //     );
    // await _dataBase.collection(userCollection).doc(uid).update({
    //   "liked_posts": FieldValue.arrayUnion([postUrl])
    // });
  }

  void unlikePost({required String uid, required Article article}) {
    getLikedPostsArray(uid: uid).then(
      (value) {
        if (value.contains(article.articleUrl)) {
          value.remove(article.articleUrl!);
          _dataBase.collection(userCollection).doc(uid).update(
            {
              postDoc: value,
            },
          );
        }
      },
    );
  }

  // bool isLiked({required String uid, required Article article}) {}

  // getCollection({required String uid, required collectionName}) {}
}
