import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final String? roomId, roomName, roomDescription, roomMembers, roomImage;
  const Body({
    super.key,
    this.roomId,
    this.roomName,
    this.roomDescription,
    this.roomMembers,
    this.roomImage,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
