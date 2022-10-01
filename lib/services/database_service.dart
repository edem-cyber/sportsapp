// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:sportsapp/models/ChatMessageModel.dart';
import 'package:sportsapp/models/Post.dart';

// Models

const String userCollection = 'Users';
const String postCollection = 'liked_posts';
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

  Future<void> updateChatData(String chatId, Map<String, dynamic> data) async {
    try {
      await _dataBase.collection(chatCollection).doc(chatId).update(data);
    } catch (error) {
      debugPrint('$error');
    }
  }

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

  // *Delete chat
  Future<void> deleteChat(String chatId) async {
    try {
      await _dataBase.collection(chatCollection).doc(chatId).delete();
    } catch (error) {
      debugPrint('$error');
    }
  }

// * Select and Create chat
  Future<DocumentReference?> createChat(Map<String, dynamic> data) async {
    try {
      final chat = await _dataBase.collection(chatCollection).add(data);
      return chat;
    } catch (error) {
      debugPrint('$error');
    }
    return null;
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
  //         .collection(postCollection)
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
  //         .collection(postCollection)
  //         .doc(postUrl)
  //         .set({
  //       "postUrl": postUrl,
  //     });
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<void> likePost({required String uid, required Article article}) async {
    // print("POST URL IS: $postUrl");
    print("UID IS: $uid");
    //add to liked posts array
    await _dataBase
        .collection(userCollection)
        .doc(uid)
        .update(
          {
            postCollection: FieldValue.arrayUnion(
              [
                article.toJson(),
              ],
            )
          },
        )
        .then((value) => print("Liked Post Added"))
        .catchError(
          (error) => print("Failed to add liked post: $error"),
        );
    // await _dataBase.collection(userCollection).doc(uid).update({
    //   "liked_posts": FieldValue.arrayUnion([postUrl])
    // });
  }

  Future<void> unlikePost({required String uid, required article}) async {
    print('unlikePost');
    await _dataBase
        .collection(userCollection)
        .doc(uid)
        .update(
          {
            postCollection: FieldValue.arrayRemove(
              [
                article.toJson(),
              ],
            )
          },
        )
        .then((value) => print("Liked Post Removed"))
        .catchError(
          (error) => print("Failed to remove liked post: $error"),
        );
  }

  // void updateUserIsNew(String uid, bool bool) {}

  // void likePost(String posturl, String uid) {
  //   //check if post is already liked
  //   isPostLiked(uid, posturl).then(
  //     (value) {
  //       if (value == false) {
  //         //if liked, unlike
  //         _dataBase.collection(userCollection).doc(uid).update(
  //           {
  //             postCollection: FieldValue.arrayRemove([posturl])
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  // void unlikePost(String postUrl, String uid) {
  //   isPostLiked(uid, postUrl).then(
  //     (value) {
  //       if (value == true) {
  //         _dataBase.collection(userCollection).doc(uid).update(
  //           {
  //             postCollection: FieldValue.arrayRemove([postUrl])
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  // Stream<List> getFollowedTopics() {}
  // Stream<List> getUsersWhoLikedPost() {
  //   var
  //   return postsRef
  //       .document(ownerId)
  //       .collection('userPosts')
  //       .document(postId)
  //       .updateData({'likes.$currentUserId': false});
  // }

  // Stream<List> getAllPosts(String uid) {
  //   return _dataBase
  //       .collection('Posts')
  //       .where('uid', isEqualTo: uid)
  //       .orderBy('created_at', descending: true)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  // }

  // Future<void> getLikedPosts(String uid) async {
  //   try {
  //     await _dataBase.collection(userCollection).doc(uid).get();
  //   } catch (e) {
  //     debugPrint('Get liked posts error: $e');
  //   }
  // }

  Future<bool> isLiked(
      {required Article article, required String uid}) async {
    try {
      final likedPosts = await _dataBase
          .collection(userCollection)
          .doc(uid)
          .collection(postCollection)
          .doc(article.articleUrl)
          .get();

      return likedPosts.exists;
    } catch (e) {
      debugPrint('Is post liked error: $e');
      return false;
    }
    // try {
    //   _dataBase.collection(userCollection).doc(uid).get().then(
    //     (value) {
    //       if (value.data()![postCollection].contains(postUrl)) {
    //         return true;
    //       } else {
    //         return false;
    //       }
    //     },
    //   );
    // } catch (e) {
    //   debugPrint('Get liked posts error: $e');
    // }
    // return false;
  }

  // bool isLiked({required String uid, required Article article}) {}

  // getCollection({required String uid, required collectionName}) {}
}
