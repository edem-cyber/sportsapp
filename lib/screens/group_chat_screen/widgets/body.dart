import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/group_chat_screen/widgets/group_from_chat_bubble.dart';
import 'package:sportsapp/screens/group_chat_screen/widgets/group_send_chat_bubble.dart';

class Body extends StatefulWidget {
  final String? roomId, roomName, roomDescription, roomImage;
  final List<String>? roomMembers;
  const Body({
    super.key,
    this.roomId,
    this.roomName,
    this.roomDescription,
    this.roomMembers,
    this.roomImage,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController roomChatController = TextEditingController();

  ScrollController scrollController = ScrollController();
  Stream<List<Map<String, dynamic>>> getRoomMessages(String roomId) {
    return FirebaseFirestore.instance
        .collection('Rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((messagesSnapshot) => messagesSnapshot.docs.map((doc) {
              final data = doc.data();
              final id = doc.id;
              final message = {
                'id': id,
                'content': data['content'],
                'senderId': data['senderId'],
                'timestamp': data['timestamp'],
              };
              return message;
            }).toList());
  }

  final GlobalKey<FormState> roomChatKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // void _scrollDown() {
    //   scrollController.animateTo(
    //     0.0,
    //     duration: const Duration(milliseconds: 500),
    //     curve: Curves.fastOutSlowIn,
    //   );
    // }

    var authProvider = Provider.of<AuthProvider>(context);

    final GlobalKey<FormState> roomChatKey = GlobalKey<FormState>();

    Future<void> sendGroupMessage({
      required String roomId,
      required Map<String, dynamic> message,
    }) async {
      try {
        DocumentReference roomRef =
            FirebaseFirestore.instance.collection("Rooms").doc(roomId);

        DocumentSnapshot roomSnapshot = await roomRef.get();

        if (roomSnapshot.exists) {
          await roomRef.collection("messages").add(message);
          await roomRef.update({
            'lastMessage': message['content'],
            'lastMessageTime': Timestamp.now(),
          });
        } else {
          throw Exception("Room does not exist.");
        }
      } catch (e) {
        debugPrint("Error in Create Chat in Room Function: $e");
      }
    }

    var themeProvider = Provider.of<ThemeProvider>(context);
    // var profile = authProvider.getProfileData(id: authProvider.user!.uid);

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: getRoomMessages(widget.roomId ?? ""),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }

                var messages = snapshot.data!.map((e) => e).toList();
                if (snapshot.hasData) {
                  return Scrollbar(
                    controller: scrollController,
                    child: ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> message = messages[index];
                        debugPrint("$message");

                        bool isSender =
                            message['senderId'] == authProvider.user!.uid;
                        // chat page body chat bubble
                        return Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: isSender
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              isSender
                                  ? GroupSendChatBubble(
                                      message: message['content'],
                                      uid: message["senderId"],
                                    )
                                  : GroupFromChatBubble(
                                      message: message['content'],
                                      senderId: message['senderId'],
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }

                return const Center(
                  child: Text(
                    "Error loading messages",
                    style: TextStyle(color: kBlue),
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
                      key: roomChatKey,
                      onWillPop: () async {
                        return true;
                      },
                      child: TextField(
                        controller: roomChatController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                        ),
                        onChanged: (value) {
                          // setState(() {
                          value = roomChatController.text;
                          // });
                        },
                        onSubmitted: (value) {
                          try {
                            sendGroupMessage(message: {
                              'content': roomChatController.text,
                              'senderId': authProvider.user!.uid,
                              'timestamp': DateTime.now(),
                              'type': 'text',
                            }, roomId: widget.roomId ?? "");
                          } catch (e) {
                            debugPrint("$e");
                          }
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
                      try {
                        sendGroupMessage(message: {
                          'content': roomChatController.text,
                          'senderId': authProvider.user!.uid,
                          'timestamp': DateTime.now(),
                          'type': 'text',
                        }, roomId: widget.roomId ?? "");

                        roomChatController.clear();
                      } catch (e) {
                        debugPrint("$e");
                      }
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
