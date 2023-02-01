import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sportsapp/screens/direct_message/body/body.dart';

class DirectMessage extends StatelessWidget {
  static const routeName = '/direct_message';
  final String? id, name, username, image;
  const DirectMessage(
      {super.key, this.id, this.name, this.username, this.image});

  @override
  Widget build(BuildContext context) {
    // set image to null
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          CachedNetworkImage(
            imageUrl: image ??
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
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(width: 10)
        ],
        title: Text(name ?? username ?? 'Direct Message'),
      ),
      body: Body(
        id: id,
        name: name,
        username: username,
        image: image,
      ),
    );
  }
}
