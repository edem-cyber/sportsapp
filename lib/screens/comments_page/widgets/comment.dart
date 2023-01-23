import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Comment extends StatelessWidget {
  final String id;
  final String text;
  const Comment({Key? key, required this.id, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<String> getImage({required String id}) async {
      var image = await FirebaseFirestore.instance
          .collection('Users')
          .doc(id)
          .get()
          .then((value) => value.data()!['photoURL']);
      return image;
    }

    return Row(
      children: [
        FutureBuilder<String>(
            future: getImage(id: id),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(snapshot.data!),
                );
              }
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: const CircleAvatar(
                  backgroundColor: Colors.grey,
                ),
              );
            }),
        const SizedBox(
          width: 20,
        ),
        Expanded(child: Text(text))
      ],
    );
  }
}
