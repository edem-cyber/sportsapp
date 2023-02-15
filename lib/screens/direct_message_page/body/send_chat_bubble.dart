import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/ChatMessageModel.dart';

class SendChatBubble extends StatelessWidget {
  // message as an object with map string dynamic
  final String message;
  const SendChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: kBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.65,
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
