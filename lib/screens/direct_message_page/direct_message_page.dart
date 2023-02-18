import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/direct_message_page/body/body.dart';

class DirectMessagePage extends StatefulWidget {
  const DirectMessagePage({super.key, this.id});

  static const routeName = '/direct_message';

  final String? id;

  @override
  State<DirectMessagePage> createState() => _DirectMessagePageState();
}

class _DirectMessagePageState extends State<DirectMessagePage> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // function that takes id and returns user object from Firestore
    final userProfile = Provider.of<AuthProvider>(context, listen: false)
        .getProfileData(id: widget.id!);

    final getSingleChatStream =
        Provider.of<AuthProvider>(context, listen: false).getSingleChatStream(
      user1: Provider.of<AuthProvider>(context, listen: false).user!.uid,
      user2: widget.id!,
    );

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: userProfile,
      builder: (context, snapshot) {
        var profile = snapshot.data != null ? snapshot.data!.data() : {};
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            actions: [
              profile != null && profile['photoURL'] != null
                  ? GestureDetector(
                      onTap: () {},
                      child: CachedNetworkImage(
                        imageUrl: profile['photoURL'],
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => const SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    )
                  : const SizedBox(width: 40),
              const SizedBox.shrink()
            ],
            title: Text(profile!['displayName'] ?? profile['username'] ?? ''),
          ),
          body: Body(
            id: widget.id,
            name: profile['displayName'],
            username: profile['username'],
            image: profile['photoURL'],
            scrollController: scrollController,
          ),
        );
      },
    );
  }
}
