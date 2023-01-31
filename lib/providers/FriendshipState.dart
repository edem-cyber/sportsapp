import 'package:flutter/material.dart';
import 'package:sportsapp/services/database_service.dart';

class FriendshipState with ChangeNotifier {
  late final DatabaseService _dataBase;
  final String userCollection = 'users';
  final String friendCollection = 'friends';

  FriendshipState() {
    _dataBase = DatabaseService();
  }

  Future<List<String>> getFriendRequests(String uid) async {
    List<String> friendRequests = [];
    try {
      friendRequests = await _dataBase.getFriendRequests(userId: uid);
    } catch (error) {
      print(
        error.toString(),
      );
    }
    return friendRequests;
  }
}
