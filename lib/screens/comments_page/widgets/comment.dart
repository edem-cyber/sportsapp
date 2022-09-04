import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Comment extends StatelessWidget {
  final String image;
  final String text;
  const Comment({Key? key, required this.image, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          // ignore: prefer_if_null_operators
          backgroundImage: CachedNetworkImageProvider(
            image,
            errorListener: () {
              Shimmer.fromColors(
                baseColor: const Color(0xFF8F8F8F),
                highlightColor: Colors.white,
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(child: Text(text))
      ],
    );
  }
}
// "Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins."