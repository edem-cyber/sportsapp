import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/screens/profile/profile.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class Comment extends StatelessWidget {
  final String id;
  final String text;

  const Comment({
    Key? key,
    required this.id,
    required this.text,
  }) : super(key: key);

  Future<String?> getImage({required String id}) async {
    var image = await FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .get()
        .then((value) => value.data()!['photoURL']);
    return image;
  }

  bool isImage(String contentType) {
    return contentType.startsWith('image/');
  }

  bool isVideo(String contentType) {
    return contentType.startsWith('video/');
  }

  Future<String> getFileType(String storageUrl) async {
    final response = await http.head(Uri.parse(storageUrl));
    final contentType = response.headers['content-type'];
    return contentType ?? '';
  }

  String extractMediaUrl(String text) {
    final urlRegex = RegExp(r'(http[s]?:\/\/[^\s]+)');
    final match = urlRegex.firstMatch(text);
    if (match != null) {
      return match.group(0)!;
    }
    return '';
  }

  Widget buildMedia(BuildContext context) {
    final mediaUrl = extractMediaUrl(text);

    if (mediaUrl.isNotEmpty) {
      return FutureBuilder<String>(
        future: getFileType(mediaUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 50,
              width: 50,
              color: Colors.grey,
            );
          } else if (snapshot.hasData) {
            final contentType = snapshot.data!;
            if (isImage(contentType)) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: BubbleNormalImage(
                  id: 'id001',
                  image: CachedNetworkImage(
                    imageUrl: mediaUrl,
                    fit: BoxFit.cover,
                    height: 200, // Adjust the desired height
                    width: double.infinity,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  color: Colors.transparent,
                  tail: true,
                  delivered: true,
                ),
              );
            } else if (isVideo(contentType)) {
              if (extractMediaUrl(text) == mediaUrl) {
                final videoPlayerController =
                    VideoPlayerController.network(mediaUrl);
                final chewieController = ChewieController(
                  videoPlayerController: videoPlayerController,
                  autoPlay: false,
                  looping: false,
                  placeholder: Container(
                    color: Colors.black,
                    child: const Stack(
                      children: [
                        Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                        Positioned.fill(
                          // child: Image.network(
                          //   'https://example.com/video_thumbnail.jpg',
                          //   fit: BoxFit.cover,
                          // ),
                          child: Center(
                            child: Text("Video"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                return SizedBox(
                  height: 200, // Adjust the desired height
                  width: double.infinity,
                  child: Chewie(
                    controller: chewieController,
                  ),
                );
              }
            }
          }
          return Container();
        },
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FutureBuilder<String?>(
          future: getImage(id: id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Profile(
                      id: id,
                    ),
                  ));
                },
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(snapshot.data!),
                ),
              );
            }
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: const CircleAvatar(
                backgroundColor: Colors.grey,
              ),
            );
          },
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (extractMediaUrl(text).isNotEmpty) buildMedia(context),
              if (!isImage(extractMediaUrl(text)) &&
                  !isVideo(extractMediaUrl(text)))
                BubbleSpecialThree(
                  text: text,
                  color: const Color(0xFFE8E8EE),
                  tail: true,
                  isSender: false,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
