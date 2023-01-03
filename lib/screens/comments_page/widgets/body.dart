import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Reply.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/comments_page/widgets/comment.dart';
// import 'package:sticky_headers/sticky_headers.dart';

class Body extends StatefulWidget {
  String? id;

  Body({Key? key, this.id}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    //textcontroller
    TextEditingController textController = TextEditingController();
    final GlobalKey<FormState> chatMessageKey = GlobalKey<FormState>();

    Future<List<Reply>> getRepliesFromSingleDoc(String pickId) async {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Picks')
          .doc(pickId)
          .collection('replies')
          .get();

      //convert to string and print
      List<Reply> replies = snapshot.docs
          .map(
            (e) => Reply.fromJson(e.data() as Map<String, dynamic>),
          )
          .toList();

      debugPrint("replies: ${replies}");
      return replies;
    }

    return SafeArea(
      child: Stack(
        // alignment: Alignment.bottomCenter,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 70),
            // color: kBlack,
            child: FutureBuilder<List<Reply>>(
                future: getRepliesFromSingleDoc(widget.id!),
                builder: (context, snapshot) {
                  return ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await getRepliesFromSingleDoc(widget.id!);
                        },
                        child: MyHeader(
                          heading: "Messi leaves Barcelona",
                          text:
                              "Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins. Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins. Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins. Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins. Cavs Guardian Penguins. Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian ",
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
                          separatorBuilder: (BuildContext context, int index) {
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
                              image: authProvider.user!.photoURL!,
                              text: snapshot.data![index].text ??
                                  "Error loading text",
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                    ],
                  );
                }),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 7, left: 10, right: 10),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      // backgroundColor: kBlue,
                      // elevation: 0,
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
                              selectionColor: kLightBlue),
                        ),
                        child: Form(
                          key: chatMessageKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter a message";
                              }
                              return null;
                            },
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 1,
                            controller: textController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: kGrey.withOpacity(0.2),
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
                    // const SizedBox(
                    //   width: 15,
                    // ),
                    GestureDetector(
                      onTap: () {
                        if (chatMessageKey.currentState!.validate()) {
                          // Retrieve the input text and submit the form
                          String message = textController.text;
                          authProvider.addReply(
                            Reply(
                              text: message,
                              timestamp: Timestamp.now().toString(),
                              author: authProvider.user!.email,
                              postId: Timestamp.now().toString(),
                            ),
                          );
                          textController.clear();
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
