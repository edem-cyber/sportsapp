import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/models/ChatMessageModel.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/direct_message_page/body/from_chat_bubble.dart';
import 'package:sportsapp/screens/direct_message_page/body/send_chat_bubble.dart';

class Body extends StatefulWidget {
  final String? id, name, username, image;
  final ScrollController scrollController;

  const Body(
      {super.key,
      this.id,
      this.name,
      this.username,
      this.image,
      required this.scrollController});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    print("${widget.id}, ${widget.name}, ${widget.username}, ${widget.image}");
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final TextEditingController dmController = TextEditingController();
    final GlobalKey<FormState> dmKey = GlobalKey<FormState>();
    void _scrollDown() {
      widget.scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }

    var authProvider = Provider.of<AuthProvider>(context, listen: true);

    void sendMessage() {
      print(dmController.text);
      if (dmKey.currentState!.validate()) {
        _scrollDown();
        authProvider.createChat(
          message: {
            'content': dmController.text,
            'sender_Id': authProvider.user!.uid,
            'timestamp': DateTime.now(),
          },
          recipientId: widget.id!,
        );
        dmController.clear();
      }
    }

    // get the chat messages function

    // chat page body
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: authProvider.getSingleChatStream(
                user1: authProvider.user!.uid,
                user2: widget.id!,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }

                List<Map<String, dynamic>> messages = snapshot.data!.docs
                    .map((e) => e.data() as Map<String, dynamic>)
                    .toList();
                return Scrollbar(
                  controller: widget.scrollController,
                  child: ListView.builder(
                    controller: widget.scrollController,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> message = messages[index];
                      bool isSender =
                          message['sender_Id'] == authProvider.user!.uid;
                      // chat page body chat bubble
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: isSender
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            isSender
                                ? SendChatBubble(
                                    message: message['content'],
                                  )
                                : FromChatBubble(
                                    message: message['content'],
                                  ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // chat page input
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // chat page input textfield
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: themeProvider.isDarkMode
                          ? Colors.grey[800]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Form(
                      key: dmKey,
                      onWillPop: () async {
                        return true;
                      },
                      child: TextField(
                        controller: dmController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                        ),
                        onChanged: (value) {
                          // setState(() {
                          value = dmController.text;
                          // });
                        },
                        onSubmitted: (value) {
                          sendMessage();
                        },
                      ),
                    ),
                  ),
                ),
                // chat page input send button
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    onPressed: () {
                      // Send chat message
                      sendMessage();
                    },
                    icon: const Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
