import 'package:flutter/material.dart';
import 'package:sportsapp/screens/group_chats_screen/body/body.dart';

class GroupChatsScreen extends StatelessWidget {
  final String? roomName, roomId, roomDescription, roomImage, roomMembers;
  const GroupChatsScreen(
      {super.key,
      this.roomName,
      this.roomId,
      this.roomDescription,
      this.roomImage,
      this.roomMembers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomName ?? "Room"),
        centerTitle: true,
      ),
      body: Body(
        roomId: roomId,
        roomName: roomName,
        roomDescription: roomDescription,
        roomImage: roomImage,
        roomMembers: roomMembers,
      ),
    );
  }
}
