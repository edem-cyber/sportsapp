import 'package:flutter/material.dart';
import 'package:sportsapp/screens/new_room_page/body/body.dart';

class NewRoomPage extends StatelessWidget {
  const NewRoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Room'),
      ),
      body: const Body(),
    );
  }
}
