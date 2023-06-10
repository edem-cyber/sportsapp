import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sportsapp/helper/constants.dart';

class SendChatBubble extends StatelessWidget {
  final String message;
  final String? senderImage;

  const SendChatBubble({Key? key, required this.message, this.senderImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
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
        ),
        if (senderImage != null)
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: CachedNetworkImageProvider(senderImage!),
                fit: BoxFit.cover,
              ),
            ),
          ),
      ],
    );
  }
}
