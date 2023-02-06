import 'package:flutter/material.dart';
import 'package:sportsapp/models/ChatMessageModel.dart';

class SendChatBubble extends StatelessWidget {
  final ChatMessage message;
  const SendChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message.content,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
