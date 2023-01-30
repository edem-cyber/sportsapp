import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Reply.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/comments_page/widgets/comment.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _scrollDown() {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
    }

    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    TextEditingController textController = TextEditingController();
    final GlobalKey<FormState> chatMessageKey = GlobalKey<FormState>();

    Future<Map<String, dynamic>?> getSinglePick({required String id}) async {
      var pick = await FirebaseFirestore.instance
          .collection('Picks')
          .doc(id)
          .get()
          .then((value) => value.data());
      print("pick is $pick");
      return pick;
    }

    Stream<List<Reply>> getRepliesFromSingleDoc(String pickId) async* {
      yield* FirebaseFirestore.instance
          .collection('Picks')
          .doc(pickId)
          .collection('replies')
          .orderBy('timestamp', descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (e) => Reply.fromJson(e.data()),
              )
              .toList());
    }

    final picker = ImagePicker();

    void pickImage() async {
      final XFile? imageFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 25,
      );
      setState(() {
        this.imageFile = imageFile;
      });
    }

    final FirebaseStorage storage = FirebaseStorage.instance;

    Future<String?> uploadPfP() async {
      try {
        File? uploadedFile = File(imageFile!.path);
        var now = DateTime.now().millisecondsSinceEpoch;
        TaskSnapshot? taskSnapshot =
            await storage.ref("images/profile_pics/$now").putFile(
                  uploadedFile,
                );
        return taskSnapshot != null
            ? await taskSnapshot.ref.getDownloadURL()
            : "";
      } catch (e) {
        print("UPLOADPFP FUNCTION!!: $e");
      }
    }

    bool isButtonEnabled = false;

    bool getIsButtonEnabled() {
      if (chatMessageKey.currentState!.validate()) {
        setState(() {
          isButtonEnabled = true;
        });
      } else {
        setState(() {
          isButtonEnabled = false;
        });
      }
      return isButtonEnabled;
    }

    void sendMessage() {
      if (chatMessageKey.currentState!.validate()) {
        _scrollDown();

        authProvider.addReply(
          Reply(
            text: textController.text,
            timestamp: Timestamp.now().toString(),
            author: authProvider.user!.uid,
          ),
          widget.id!,
        );
        textController.clear();
      }
    }

    bool validateChatMessage(String? value) {
      bool isValid = false;
      RegExp regExp = RegExp(r'^\s+$');
      if (value == null || value.isEmpty) {
        isValid = false;
      } else if (value.length > 400) {
        isValid = false;
      } else if (value.length < 2) {
        isValid = false;
      } else if (regExp.hasMatch(value)) {
        isValid = false;
      } else {
        isValid = true;
      }

      setState(() {
        isButtonEnabled = isValid;
      });

      return isValid;
    }

    return SafeArea(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 20),
            child: StreamBuilder<List<Reply>>(
              stream: getRepliesFromSingleDoc(widget.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none ||
                    snapshot.data == null) {
                  return const Center(child: CupertinoActivityIndicator());
                } else if (snapshot.hasData) {
                  return Scrollbar(
                    thumbVisibility: true,
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                );
                              }
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
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
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
                        const SizedBox(
                          height: 20,
                        ),
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
                                child: const VerticalDivider(
                                  color: kGrey,
                                ),
                              );
                            },
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Comment(
                                id: snapshot.data![index].author ??
                                    "Error loading image",
                                text: snapshot.data![index].text ??
                                    "Error loading text",
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 10,
                        ),
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
                        pickImage();
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
                            // onChanged: (value) {
                            //   if (value.isEmpty) {
                            //     setState(() {
                            //       getIsButtonEnabled();
                            //     });
                            //   }
                            // },
                            // validator: (value) {
                            //   // var isValid = validateChatMessage(value!);

                            //   if (chatMessageKey.currentState!.validate()) {
                            //   } else {
                            //     return null;
                            //   }
                            // },
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
                        if (chatMessageKey.currentState!.validate()) {
                          if (textController.text.trim().isNotEmpty) {
                            sendMessage();
                          }
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
              )),
        ],
      ),
    );
  }
}

class MyHeader extends StatelessWidget {
  String? text;
  String? heading;
  MyHeader({
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
