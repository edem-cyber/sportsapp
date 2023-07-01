import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/PickReply.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/comments_page/widgets/comment.dart';
import 'package:video_player/video_player.dart';

class Body extends StatefulWidget {
  final String? id;
  final ScrollController scrollController;

  const Body({
    Key? key,
    this.id,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  XFile? imageFile;

  void scrollDown() {
    widget.scrollController.animateTo(
      widget.scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   scrollDown();
    // });
  }

  TextEditingController textController = TextEditingController();
  // late File? _imageFile;

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    final GlobalKey<FormState> chatMessageKey = GlobalKey<FormState>();

    Future<Map<String, dynamic>?> getSinglePick({required String id}) async {
      var pick = await FirebaseFirestore.instance
          .collection('Picks')
          .doc(id)
          .get()
          .then(
            (value) => value.data(),
          );
      debugPrint("pick is $pick");
      return pick;
    }

    Stream<List<PickReply>> getRepliesFromSingleDoc(String pickId) async* {
      yield* FirebaseFirestore.instance
          .collection('Picks')
          .doc(pickId)
          .collection('replies')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map(
                  (e) => PickReply.fromJson(
                    e.data(),
                  ),
                )
                .toList(),
          );
    }

    FilePickerResult? filePickerResult;
    File? pickedFile;

    Future<void> uploadMediaToFirebase(
      File file,
    ) async {
      try {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('Media')
            .child('${DateTime.now().millisecondsSinceEpoch}');
        final UploadTask uploadTask = storageRef.putFile(file);
        final TaskSnapshot uploadSnapshot = await uploadTask;

        if (uploadSnapshot.state == TaskState.success) {
          final String downloadUrl = await storageRef.getDownloadURL();

          // Save the download URL and other metadata to Firestore
          // await FirebaseFirestore.instance.collection('P').add({
          //   'mediaUrl': downloadUrl,
          //   'mediaType': fileExtension,
          //   'timestamp': FieldValue.serverTimestamp(),
          // });

          //the below fucntion just adds whatever
          authProvider.addPickReply(
            PickReply(
              text: downloadUrl,
              timestamp: Timestamp.now().toString(),
              author: authProvider.user!.uid,
              type: "Media",
            ),
            widget.id!,
          );

          // Perform any additional actions if needed
        } else {
          // Handle the upload failure
        }
      } catch (e) {
        // Handle any errors that occurred during the upload process
      }
    }

    getImageorVideoFromGallery(context) async {
      filePickerResult = await FilePicker.platform.pickFiles();

      if (filePickerResult != null) {
        pickedFile = File(
          filePickerResult!.files.single.path.toString(),
        );
        // String? fileExtension = filePickerResult!.files.single.extension;

        // Upload the media file to Firebase Storage and save metadata in Firestore
        uploadMediaToFirebase(
          pickedFile!,
          // fileExtension!,
        );
      } else {
        // Can perform some actions like notification, show error message, etc.
      }
    }

    void sendMessage() async {
      if (chatMessageKey.currentState!.validate()) {
        scrollDown();

        authProvider.addPickReply(
          PickReply(
            text: textController.text,
            timestamp: Timestamp.now().toString(),
            author: authProvider.user!.uid,
            type: "String",
          ),
          widget.id!,
        );
        textController.clear();
      }
    }

    Widget buildShimmerContainer() {
      return Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: kGrey.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.white,
            child: Container(
              height: 35,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    Widget buildComment(PickReply comment) {
      return Comment(
        id: comment.author ?? "Error loading image",
        text: comment.text ?? "Error loading text",
      );
    }

    return SafeArea(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: StreamBuilder<List<PickReply>>(
              stream: getRepliesFromSingleDoc(widget.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none ||
                    snapshot.data == null) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return Scrollbar(
                    thumbVisibility: true,
                    controller: widget.scrollController,
                    child: ListView(
                      controller: widget.scrollController,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: FutureBuilder<Map<String, dynamic>?>(
                            future: getSinglePick(id: widget.id!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return MyHeader(
                                  heading: snapshot.data!['title'],
                                  text: snapshot.data!['desc'],
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return buildShimmerContainer();
                              }
                              return buildShimmerContainer();
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Comments & Replies",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Container(
                                padding: const EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                height: 50,
                                child: const VerticalDivider(color: kGrey),
                              );
                            },
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              final comment = snapshot.data![index];
                              return buildComment(comment);
                            },
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 10),
                      ],
                    ),
                  );
                }
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.only(top: 7, left: 10, right: 10),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      getImageorVideoFromGallery(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        right: 10,
                        top: 15,
                        bottom: 15,
                      ),
                      child: const Icon(
                        Icons.image_outlined,
                        color: kBlue,
                        size: 30,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Theme(
                      data: ThemeData(
                        textSelectionTheme: const TextSelectionThemeData(
                          selectionColor: kLightBlue,
                        ),
                      ),
                      child: Form(
                        key: chatMessageKey,
                        child: TextFormField(
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 1,
                          controller: textController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: kGrey.withOpacity(0.15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Start a message...",
                            hintStyle: Theme.of(context).textTheme.bodyLarge,
                          ),
                          textInputAction: TextInputAction.newline,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (chatMessageKey.currentState!.validate() &&
                          textController.text.trim().isNotEmpty) {
                        sendMessage();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 15,
                        bottom: 15,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: kBlue,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyHeader extends StatelessWidget {
  final String? text;
  final String? heading;
  const MyHeader({
    Key? key,
    this.text,
    this.heading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: kGrey.withOpacity(0.4),
          borderRadius: const BorderRadius.all(
            Radius.circular(40),
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: kLightBlue,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                heading ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                text ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageBlock extends StatefulWidget {
  final File file;
  const ImageBlock({Key? key, required this.file}) : super(key: key);
  @override
  State<ImageBlock> createState() => _ImageBlockState();
}

class _ImageBlockState extends State<ImageBlock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.file(widget.file)));
  }
}

////////// video screen ///////////

class VideoBlock extends StatefulWidget {
  final File file;
  const VideoBlock({Key? key, required this.file}) : super(key: key);
  @override
  State<VideoBlock> createState() => _VideoBlockState();
}

class _VideoBlockState extends State<VideoBlock> {
  VideoPlayerController? videoPlayerController;
  @override
  void initState() {
    videoPlayerController =
        VideoPlayerController.file(File(widget.file.path.toString()))
          ..initialize().then((_) {
            videoPlayerController!.play();
            setState(() {});
          });
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: videoPlayerController!.value.aspectRatio,
          child: VideoPlayer(videoPlayerController!),
        ),
      ),
    );
  }
}
