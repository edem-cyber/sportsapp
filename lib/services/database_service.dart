// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:sportsapp/models/Post.dart';
import 'package:sportsapp/models/Reply.dart';

// Models

const String userCollection = 'Users';
const String userNamesCollection = 'Usernames';
const String postDoc = 'liked_posts';
const String chatCollection = 'Chats';
const String roomsCollection = 'Rooms';

const String messagesCollection = 'Messages';

class DatabaseService {
  DatabaseService();
  final FirebaseFirestore _dataBase = FirebaseFirestore.instance;
  // var postsRef = FirebaseFirestore.instance.collection(userCollection);

  // Future<bool> isDuplicateUsername(String username) async {
  //   final QuerySnapshot result = await _dataBase
  //       .collection(userNamesCollection)
  //       .where('username', isEqualTo: username)
  //       .get();
  //   final List<DocumentSnapshot> documents = result.docs;
  //   return documents.length == 1;
  // }

  Future<bool> isDuplicateUsername(String username) async {
    final result = await _dataBase
        .collection(userCollection)
        .where('username', isEqualTo: username)
        .get();
    return result.docs.isNotEmpty;
  }

  Future addUserInfoToDB(
      {required String uid, required Map<String, dynamic> userInfoMap}) {
    return _dataBase.collection(userCollection).doc(uid).set(userInfoMap);
  }

  // void addReply(Reply reply) {
  //   _dataBase.collection('replies').add(
  //     {
  //       'text': reply.text,
  //       'author': reply.author,
  //       'timestamp': reply.timestamp,
  //       'postId': reply.postId,
  //     },
  //   );
  // }

  Future<void> addReply(Reply reply) async {
    await _dataBase
        .collection('Picks')
        .doc(
          reply.postId.toString(),
        )
        .collection('replies')
        .add(reply.toJson());
  }

  //Update User
  Future<void> updateUser(
      {required String uid,
      String? displayName,
      String? bio,
      String? photoUrl}) async {
    try {
      // * Going to the collections (User) the to the user uid and overrides the values of the fields
      await _dataBase.collection(userCollection).doc(uid).update({
        'displayName': displayName,
        'bio': bio,
        'photoURL': photoUrl,
      });
    } catch (error) {
      debugPrint('$error');
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(
      {required String uid}) async {
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

//get likes from likes array

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
          'last_active': DateTime.now(),
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
    // debugPrint('LIKELIST: $likeList');

    return likeList;
  }

  Future createPick({required String title, required String desc}) {
    return _dataBase.collection('Picks').add(
      {
        'title': title,
        'desc': desc,
        'created_at': DateTime.now(),
      },
    );
  }

  //delete pick from firestore
  Future deletePick({required String id}) {
    //search pick by index and delete it
    return _dataBase.collection('Picks').doc(id).delete();
  }

  Future<bool> isPostInLikedArray(
      {required String uid, required Article article}) async {
    List<String> likeList = await getLikedPostsArray(uid: uid);
    bool isLiked = likeList.contains(article.articleUrl);
    return isLiked;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPicks() async {
    return await _dataBase.collection('Picks').get();
  }

  //function to

  // Stream<bool> isPostLikedList(
  //     {required String uid, required Article article}) {
  //   List<String> likeList = await getLikedPostsArray(uid: uid);
  //   var isLiked = likeList.contains(article);
  //     }

  likePost({required String uid, required Article article}) {
    // var isLiked = isPostLiked(uid: uid, article: article).then(
    //   (value) {
    //     return value;
    //   },
    // );

    _dataBase
        .collection(userCollection)
        .doc(uid)
        .update(
          {
            postDoc: FieldValue.arrayUnion(
              [
                article.articleUrl.toString(),
              ],
            )
          },
        )
        .then((value) => print("Liked Post Added"))
        .catchError(
          (error) => print("Failed to add liked post: $error"),
        );
    // await _dataBase.collection(userCollection).doc(uid).update({
    //   postDoc: FieldValue.arrayUnion([article.articleUrl.toString()])
    // });
  }

  void unlikePost({required String uid, required Article article}) {
    _dataBase
        .collection(userCollection)
        .doc(uid)
        .update(
          {
            postDoc: FieldValue.arrayRemove(
              [
                article.articleUrl.toString(),
              ],
            )
          },
        )
        .then((value) => print("Liked Post Removed"))
        .catchError(
          (error) => print("Failed to remove liked post: $error"),
        );
  }

  void removeFromDb({
    required String uid,
    required String postUrl,
  }) {
    _dataBase
        .collection(userCollection)
        .doc(uid)
        .update(
          {
            postDoc: FieldValue.arrayRemove(
              [
                postUrl.toString(),
              ],
            )
          },
        )
        .then((value) => print("Liked Post Removed"))
        .catchError(
          (error) => print("Failed to remove liked post: $error"),
        );
  }

  sendPost({required String message, required String uid}) {
    // _dataBase.collection("posts").doc()
  }

  // Future<bool> toggleLikedPost(
  //     {required String uid, required Article article}) async {
  //   bool isLiked = await isPostInLikedArray(uid: uid, article: article);
  //   if (isLiked) {
  //     unlikePost(uid: uid, article: article);
  //   } else {
  //     likePost(uid: uid, article: article);
  //   }
  //   return !isLiked;
  // }

  // bool isLiked({required String uid, required Article article}) {}

  // getCollection({required String uid, required collectionName}) {}
}
