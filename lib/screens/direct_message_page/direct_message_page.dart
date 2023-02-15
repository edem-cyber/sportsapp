import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/direct_message_page/body/body.dart';

class DirectMessagePage extends StatelessWidget {
  static const routeName = '/direct_message';
  String? id;
  DirectMessagePage({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    // function that takes id and returns user object from Firestore
    final userProfile =
        Provider.of<AuthProvider>(context, listen: false).getProfileData(
      id: id!,
    );

    final getSingleChatStream =
        Provider.of<AuthProvider>(context, listen: false).getSingleChatStream(
      user1: Provider.of<AuthProvider>(context, listen: false).user!.uid,
      user2: id!,
    );

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: userProfile,
      builder: (context, snapshot) {
        var profile = snapshot.data != null ? snapshot.data!.data() : {};
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              CachedNetworkImage(
                imageUrl: profile!['photoURL'] ??
                    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                imageBuilder: (context, imageProvider) => Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const CupertinoActivityIndicator(),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              ),
              const SizedBox(width: 10)
            ],
            title: Text(profile['displayName'] ??
                profile['username'] ??
                ''),
          ),
          body: Body(
            id: id,
            name: profile['displayName'],
            username: profile['username'],
            image: profile['photoURL'],
            scrollController: ScrollController(),
          ),
        );
      },
    );
  }
}
