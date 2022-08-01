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

  // Create User
  // Future<void> createUser(
  //     String _uid, String _email, String _name, String _photoURL) async {
  //   try {
  //     // * Going to the collections (User) the to the user uid and overrides the values of the fields
  //     await _dataBase.collection(userCollection).doc(_uid).set(
  //       {
  //         'name': _name,
  //         'email': _email,
  //         'image': _photoURL,
  //         'last_active': DateTime.now().toUtc(),
  //       },
  //     );
  //   } catch (error) {
  //     debugPrint('$error');
  //   }
  // }

  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    String? photoURL,
  }) async {
    try {
      // * Going to the collections (User) the to the user uid and overrides the values of the fields
      await _dataBase.collection(userCollection).doc(uid).set(
        {
          'name': name,
          'email': email,
          'image': photoURL ?? '',
          'last_active': DateTime.now().toUtc(),
        },
      );
    } catch (error) {
      debugPrint('$error');
    }
  }

  Future addUserInfoToDB(String uid, Map<String, dynamic> userInfoMap) {
    return _dataBase.collection(userCollection).doc(uid).set(userInfoMap);
  }

  Future getUserFromDB(String uid) {
    return _dataBase.collection(userCollection).doc(uid).get();
  }

  //* Getting the User from Firebase Cloud Store
  Future<DocumentSnapshot> getUser(String _uid, {String? name}) {
    return _dataBase.collection(userCollection).doc(_uid).get();
  }

  Future<QuerySnapshot> getUsers({String? name}) {
    Query _query = _dataBase.collection(userCollection);
    if (name != null) {
      _query = _query.where('name', isGreaterThanOrEqualTo: name).where(
            'name',
            isLessThanOrEqualTo: name + 'z',
          );
    }
    return _query.get();
  }

//* Getting the chats from the users
  Stream<QuerySnapshot> getChatsForsUser(String _uid) {
    return _dataBase
        .collection(chatCollection)
        .where(
          'members',
          arrayContains: _uid,
        )
        .snapshots();
  }

  //* Update to the last chat sent
  Future<QuerySnapshot> getLastMessageFroChat(String _chatID) {
    return _dataBase
        .collection(chatCollection)
        .doc(_chatID)
        .collection(messagesCollection)
        .orderBy(
          'sent_time',
          descending: true,
        )
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChatPage(String _chatId) {
    return _dataBase
        .collection(chatCollection)
        .doc(_chatId)
        .collection(messagesCollection)
        .orderBy('sent_time', descending: false)
        .snapshots();
  }

  // * Add messages to the firestore databse
  Future<void> addMessagesToChat(String _chatId, ChatMessage _message) async {
    try {
      await _dataBase
          .collection(chatCollection)
          .doc(_chatId)
          .collection(messagesCollection)
          .add(
            _message.toJson(),
          );
    } catch (error) {
      debugPrint('$error');
    }
  }

  Future<void> updateChatData(
      String _chatId, Map<String, dynamic> _data) async {
    try {
      await _dataBase.collection(chatCollection).doc(_chatId).update(_data);
    } catch (error) {
      debugPrint('$error');
    }
  }

//* Update time
  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _dataBase.collection(userCollection).doc(_uid).update(
        {
          'last_active': DateTime.now().toUtc(),
        },
      );
    } catch (e) {
      debugPrint('$e');
    }
  }

  // *Delete chat
  Future<void> deleteChat(String _chatId) async {
    try {
      await _dataBase.collection(chatCollection).doc(_chatId).delete();
    } catch (error) {
      debugPrint('$error');
    }
  }

// * Select and Create chat
  Future<DocumentReference?> createChat(Map<String, dynamic> _data) async {
    try {
      final _chat = await _dataBase.collection(chatCollection).add(_data);
      return _chat;
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

  Stream<List> getAllPosts(String uid) {
    return _dataBase
        .collection('Posts')
        .where('uid', isEqualTo: uid)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
