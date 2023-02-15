// Packages
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:sportsapp/models/ChatMessageModel.dart';
import 'package:sportsapp/models/Post.dart';
import 'package:sportsapp/models/PickReply.dart';
import 'package:sportsapp/screens/picks/picks.dart';

// Models

const String userCollection = 'Users';
const String userNamesCollection = 'Usernames';
const String postDoc = 'liked_posts';
const String chatCollection = 'Chats';
const String roomsCollection = 'Rooms';

const String messagesCollection = 'messages';

class DatabaseService {
  DatabaseService();
  final FirebaseFirestore _dataBase = FirebaseFirestore.instance;

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

  Future<void> addPickReply(PickReply reply, doc) async {
    await _dataBase
        .collection('Picks')
        .doc(
          doc,
        )
        .collection('replies')
        .add(
          reply.toJson(),
        );
  }

//* Getting the chats from the users
  Stream<QuerySnapshot> getChatsForUser({required String uid}) {
    return _dataBase
        .collection(chatCollection)
        .where((doc) => doc.documentID.contains(uid))
        .snapshots();
  }

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

  Future<DocumentSnapshot> getLastMessageForChat(
      {required String chatId}) async {
    final QuerySnapshot<Map<String, dynamic>> messages = await FirebaseFirestore
        .instance
        .collection(chatCollection)
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    return messages.docs.first;
  }

  //   // await chatRef.set({
  //   //   'messages': [chatMessage.toJson()],
  //   // });

  //   // add chat to sender and reciever docs in users collection as subcollection
  //   await _dataBase
  //       .collection('Users')
  //       .doc(message.senderID)
  //       .collection('Chats')
  //       .doc("$chatId ")
  //       .set({"chats.$chatId": chatRef});

  //   await _dataBase
  //       .collection('Users')
  //       .doc(recipientId)
  //       .collection('Chats')
  //       .doc("/Chats/$chatId");
  //   // .set({"chats.$chatId": chatRef});

  //   // await chatRef.update({
  //   //   'members': [message.senderID, recipientId],
  //   // });

  //   // await chatRef.collection("messages").add(chatMessage.toJson());
  // }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createChat(
      {required String user1,
      required String user2,
      required Map<String, dynamic> message}) async {
    try {
      List<String> sortedMembers = [user1, user2]..sort();
      String chatId = sortedMembers.join('-');
      DocumentReference chatRef =
          _firestore.collection(chatCollection).doc(chatId);
      DocumentSnapshot chatSnapshot = await chatRef.get();
      if (!chatSnapshot.exists) {
        await chatRef.set({
          'members': [user1, user2],
        });
        await chatRef.collection("messages").add(message);
        await _firestore
            .collection(userCollection)
            .doc(user1)
            .collection(chatCollection)
            .doc(chatId)
            .set({"chat": chatRef});
        await _firestore
            .collection(userCollection)
            .doc(user2)
            .collection(chatCollection)
            .doc(chatId)
            .set({"chat": chatRef});
      } else {
        await chatRef.collection("messages").add(message);
      }
    } catch (e) {
      print("Error in Create Chat Function: $e");
    }
  }

  Stream<QuerySnapshot> getSingleChatStream({
    required String user1,
    required String user2,
  }) {
    // String chatId = "$user1-$user2";
    // make chatId the same for both users
    // help me wrrite the chatid to be one for both users
    List<String> sortedMembers = [user1, user2]..sort();
    String chatId = sortedMembers.join('-');

    return _firestore
        .collection(chatCollection)
        .doc(chatId)
        .collection("messages")
        .orderBy('timestamp', descending: true)
        .snapshots();
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

  // // // * Add messages to the firestore databse
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

  Future<List<String>> getFriendRequests({required String userId}) async {
    List<String> friends = [];
    try {
      QuerySnapshot friendRequests = await _dataBase
          .collection(userCollection)
          .doc(userId)
          .collection('friends')
          .where('status', isEqualTo: 'pending')
          .get();
      for (var element in friendRequests.docs) {
        friends.add(element.id);
      }
    } catch (error) {
      debugPrint('$error');
    }

    return friends;
  }

  Future<List<String>> getFriends({required String userId}) async {
    List<String> friends = [];
    try {
      QuerySnapshot friendRequests = await _dataBase
          .collection(userCollection)
          .doc(userId)
          .collection('friends')
          .where('status', isEqualTo: 'accepted')
          .get();
      for (var element in friendRequests.docs) {
        friends.add(element.id);
      }
    } catch (error) {
      debugPrint('$error');
    }

    return friends;
  }

  // Send a friend request
  Future<void> sendFriendRequest(
      {required String senderId, required String receiverId}) async {
    try {
      await _dataBase
          .collection(userCollection)
          .doc(receiverId)
          .collection('friends')
          .doc(senderId)
          .set({'status': 'pending'});
      await _dataBase
          .collection(userCollection)
          .doc(senderId)
          .collection('friends')
          .doc(receiverId)
          .set({'status': 'sent'});
    } catch (error) {
      debugPrint('$error');
    }
  }

// Accept a friend request
  Future<void> acceptFriendRequest(
      {required String senderId, required String receiverId}) async {
    try {
      await _dataBase
          .collection(userCollection)
          .doc(receiverId)
          .collection('friends')
          .doc(senderId)
          .update({'status': 'accepted'});
      await _dataBase
          .collection(userCollection)
          .doc(senderId)
          .collection('friends')
          .doc(receiverId)
          .update({'status': 'accepted'});
    } catch (error) {
      debugPrint('$error');
    }
  }

// Cancel a friend request
  Future<void> cancelFriendRequest(
      {required String senderId, required String receiverId}) async {
    try {
      await _dataBase
          .collection(userCollection)
          .doc(receiverId)
          .collection('friends')
          .doc(senderId)
          .delete();
      await _dataBase
          .collection(userCollection)
          .doc(senderId)
          .collection('friends')
          .doc(receiverId)
          .delete();
    } catch (error) {
      debugPrint('$error');
    }
  }

// Remove a friend
  Future<void> removeFriend(
      {required String userId, required String friendId}) async {
    try {
      // Remove the friend from the user's friends list
      await _dataBase
          .collection(userCollection)
          .doc(userId)
          .collection('friends')
          .doc(friendId)
          .delete();
      // Remove the user from the friend's friends list
      await _dataBase
          .collection(userCollection)
          .doc(friendId)
          .collection('friends')
          .doc(userId)
          .delete();
    } catch (error) {
      debugPrint('$error');
    }
  }

  // check if friends or not

  Future<String> checkIfFriends(
      {required String userId, required String friendId}) {
    String status = '';
    _dataBase
        .collection(userCollection)
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .get()
        .then((value) {
      value.data() != null && value.data()!['status'];

      if (value.data() != null) {
        status = value.data()!['status'];
      }
    });

    return Future.value(status);
  }

  // check friend status
  Future<String> getFriendStatus(
      {required String userId, required String friendId}) {
    String status = '';
    _dataBase
        .collection(userCollection)
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .get()
        .then((value) {
      if (value.data() != null) {
        status = value.data()!['status'];
      }
    });

    return Future.value(status);
  }

  // check friend status
  Stream<String> getFriendStatusStream(
      {required String userId, required String friendId}) {
    return _dataBase
        .collection(userCollection)
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.data() != null) {
        print('friend status: ${snapshot.data()!['status']}');
        return snapshot.data()!['status'];
      } else {
        return '';
      }
    });
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

  Future<List<Map<String, dynamic>>> searchUsers(String searchTerm) async {
    List<Map<String, dynamic>> users = [];

    try {
      var query = _dataBase
          .collection(userCollection)
          .where("username", isEqualTo: searchTerm)
          .limit(20)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

      await query.forEach((element) {
        users = element;
      });
    } catch (error) {
      debugPrint("Error while searching users: $error");
    }

    debugPrint("search users: $users");
    return users;
  }

  // Future<bool> setBookmarks(
  //     {required String sneurceName,
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
        //new collection for replies
      },
    );
  }

  //delete pick from firestore
  Future deletePick({required String id}) {
    //search pick by index and delete it
    return _dataBase.collection('Picks').doc(id).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> searchPicks(
      {String? searchTerm}) {
    return _dataBase
        .collection('Picks')
        .orderBy('title', descending: true)
        // .toString()
        // convert everything to lower case
        .where('title', isGreaterThanOrEqualTo: searchTerm)
        .snapshots();
  }

  //stream is post in liked array
  Future<bool> isPostInLikedArray(
      {required String uid, required Article article}) async {
    return _dataBase.collection(userCollection).doc(uid).get().then((value) {
      List<String> likeList = List.from(value.data()![postDoc]);
      bool isLiked = likeList.contains(article.articleUrl);
      return isLiked;
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllPicks() async {
    // return await _dataBase.collection('Picks').get();
    // get picks and order by created_at
    return await _dataBase
        .collection('Picks')
        .orderBy('created_at', descending: false)
        .get();
  }

  likePost({required String uid, required Article article}) {
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
        .then((value) => debugPrint("Liked Post Added"))
        .catchError(
          (error) => debugPrint("Failed to add liked post: $error"),
        );
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
        .then((value) => debugPrint("Liked Post Removed"))
        .catchError(
          (error) => debugPrint("Failed to remove liked post: $error"),
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
        .then((value) => debugPrint("Liked Post Removed"))
        .catchError(
          (error) => debugPrint("Failed to remove liked post: $error"),
        );
  }

  sendPost(
      {required String message, required String id, required String photoURL}) {
    _dataBase
        .collection("Picks")
        .doc(
          id,
        )
        .set(
      {
        "message": message,
        "photoURL": photoURL,
        "created_at": DateTime.now(),
      },
    );
  }

  Future<int> getRepliesCount({required String id}) {
    return _dataBase
        .collection("Picks")
        .doc(id)
        .collection("replies")
        .get()
        .then((snapshot) => snapshot.size);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatMessages(
      {required String chatId}) {
    return _dataBase
        .collection("Picks")
        .doc(chatId)
        .collection("replies")
        .orderBy("created_at", descending: true)
        .snapshots();
  }
}
