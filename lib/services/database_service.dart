// Packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:sportsapp/models/ChatMessageModel.dart';

// Models

const String userCollection = 'Users';
const String chatCollection = 'Chats';
const String messagesCollection = 'Messages';

class DatabaseService {
  DatabaseService();
  final FirebaseFirestore _dataBase = FirebaseFirestore.instance;
  // var postsRef = FirebaseFirestore.instance.collection(userCollection);

  Future<bool> isDuplicateUniqueName(String? username) async {
    QuerySnapshot query = await _dataBase
        .collection(userCollection)
        .where('username', isEqualTo: username)
        .get();
    return query.docs.isNotEmpty;
  }



  Future addUserInfoToDB(String uid, Map<String, dynamic> userInfoMap) {
    return _dataBase.collection(userCollection).doc(uid).set(userInfoMap);
  }

  //firestore function to add to likes
  

  //Update User
  Future<void> updateUser(String uid, Map<String, dynamic> userInfoMap) async {
    try {
      // * Going to the collections (User) the to the user uid and overrides the values of the fields
      await _dataBase.collection(userCollection).doc(uid).update(userInfoMap);
    } catch (error) {
      debugPrint('$error');
    }
  }

  Future getUserFromDB(String uid) {
    return _dataBase.collection(userCollection).doc(uid).get();
  }

  //* Getting the User from Firebase Cloud Store
  Future<DocumentSnapshot> getUser(String uid, {String? name}) {
    return _dataBase.collection(userCollection).doc(uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query query = _dataBase.collection(userCollection);
    if (name != null) {
      query = query.where('name', isGreaterThanOrEqualTo: name).where(
            'name',
            isLessThanOrEqualTo: name + 'z',
          );
    }
    return query.get();
  }

//* Getting the chats from the users
  Stream<QuerySnapshot> getChatsForsUser(String uid) {
    return _dataBase
        .collection(chatCollection)
        .where(
          'members',
          arrayContains: uid,
        )
        .snapshots();
  }

  //* Update to the last chat sent
  Future<QuerySnapshot> getLastMessageFroChat(String chatID) {
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

  Stream<QuerySnapshot> streamMessagesForChatPage(String chatId) {
    return _dataBase
        .collection(chatCollection)
        .doc(chatId)
        .collection(messagesCollection)
        .orderBy('sent_time', descending: false)
        .snapshots();
  }



  // * Add messages to the firestore databse
  Future<void> addMessagesToChat(String chatId, ChatMessage message) async {
    try {
      await _dataBase
          .collection(chatCollection)
          .doc(chatId)
          .collection(messagesCollection)
          .add(
            message.toJson(),
          );
    } catch (error) {
      debugPrint('$error');
    }
  }

  Future<void> updateChatData(String chatId, Map<String, dynamic> data) async {
    try {
      await _dataBase.collection(chatCollection).doc(chatId).update(data);
    } catch (error) {
      debugPrint('$error');
    }
  }

//* Update time
  Future<void> updateUserLastSeenTime(String uid) async {
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

  // Stream<List> getFollowedTopics() {}
  // Stream<List> getUsersWhoLikedPost() {
  //   var 
  //   return postsRef
  //       .document(ownerId)
  //       .collection('userPosts')
  //       .document(postId)
  //       .updateData({'likes.$currentUserId': false});
  // }

  Stream<List> getAllPosts(String uid) {
    return _dataBase
        .collection('Posts')
        .where('uid', isEqualTo: uid)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }



  getCollection({required String uid, required collectionName}) {}
}
