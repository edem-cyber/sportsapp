import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/ChatMessageModel.dart';
import 'package:sportsapp/providers/AuthProvider.dart';

class GroupSendChatBubble extends StatelessWidget {
  final String message;

  final String? uid;

  const GroupSendChatBubble({Key? key, required this.message, this.uid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var aP = Provider.of<AuthProvider>(context, listen: false);
    var profile = aP.getProfileData(id: aP.user!.uid);
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
        if (uid != null)
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: profile,
              builder: (context, snapshot) {
                var user = snapshot.data != null
                    ? snapshot.data!.data()
                    : {
                        'displayName': 'User',
                        'username': 'User',
                        'photoURL':
                            'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                      };
                return Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        user!["photoURL"],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
      ],
    );
  }
}
