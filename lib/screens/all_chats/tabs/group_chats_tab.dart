import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/group_chat_screen/group_chat_screen.dart';
// import 'package:sportsapp/services/database_service.dart';

class GroupChatsTab extends StatefulWidget {
  const GroupChatsTab({
    Key? key,
  }) : super(key: key);

  @override
  State<GroupChatsTab> createState() => _GroupChatsTabState();
}

class _GroupChatsTabState extends State<GroupChatsTab>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<GroupChatsTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    TextEditingController roomTitleController = TextEditingController();
    TextEditingController roomDescriptionController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    TextFormField buildRoomTitleFormField() {
      return TextFormField(
        controller: roomTitleController,
        validator: (value) {
          if (value!.isEmpty) {
            return;
          }
          return;
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Room Title",
          // floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (value) {
          value = roomTitleController.text;
        },
      );
    }

    TextFormField buildRoomDescriptionFormField() {
      return TextFormField(
        controller: roomDescriptionController,
        validator: (value) {
          if (value!.isEmpty) {
            return;
          }
          return;
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Room Description",
          // floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onChanged: (value) {
          value = roomDescriptionController.text;
        },
      );
    }

    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    Future<void> createRoom(
        {required String roomName, required String description}) async {
      final roomDoc = FirebaseFirestore.instance.collection('Rooms').doc();
      // var userDoc = FirebaseFirestore.instance
      //     .collection(userCollection)
      //     .doc(authProvider.user!.uid);
      final members = [authProvider.user!.uid];
      final timestamp = FieldValue.serverTimestamp();
      // final senderRef = FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc(authProvider.user!.uid);

      final batch = FirebaseFirestore.instance.batch();

      batch.set(roomDoc, {
        'roomName': roomName,
        'description': description,
        'members': members,
        'admin': authProvider.user!.uid,
        'lastMessage': 'Welcome to $roomName room!',
        'lastMessageTimestamp': timestamp,
        'roomImage': '',
        'createdAt': timestamp
      });

      final messagesCollection = roomDoc.collection('messages');
      final firstMessageDoc = messagesCollection.doc();

      batch.set(firstMessageDoc, {
        'senderId': authProvider.user!.uid,
        'content': 'Welcome to $roomName group chat!',
        'type': 'text',
        'timestamp': timestamp
      });

      return batch.commit();
    }

    Stream<List<Map<String, dynamic>>> getUserRooms(String userId) {
      return FirebaseFirestore.instance
          .collection('Rooms')
          .where('members', arrayContains: userId)
          // .orderBy("lastMessageTimestamp")
          .snapshots()
          .map((roomsSnapshot) => roomsSnapshot.docs.map((doc) {
                final data = doc.data();
                final id = doc.id;
                final room = {
                  'id': id,
                  'roomName': data['roomName'],
                  'description': data['description'],
                  'members': List<String>.from(data['members']),
                  'admin': data['admin'],
                  'lastMessage': data['lastMessage'],
                  'lastMessageTimestamp': data['lastMessageTimestamp'],
                  'createdAt': data['createdAt'],
                  'roomImage': data['roomImage'],
                };
                return room;
              }).toList()
                ..sort((a, b) => a['lastMessageTimestamp']
                    .compareTo(b['lastMessageTimestamp'])));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // cupertino modal to create new room
          showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              title: const Text('Create New Room'),
              actions: [
                CupertinoActionSheetAction(
                  child: const Text('Create Room'),
                  onPressed: () {
                    showModalBottomSheet(
                        isDismissible: true,
                        clipBehavior: Clip.antiAlias,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        enableDrag: true,
                        isScrollControlled: true,
                        anchorPoint: const Offset(0, 1),
                        context: context,
                        builder: (context) {
                          return Builder(builder: (context) {
                            return Material(
                              child: Form(
                                key: formKey,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.95,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SafeArea(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20,
                                                              bottom: 20),
                                                      child: const Icon(
                                                        Icons.close,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // const SizedBox(height: 10),
                                              Text("Create a Room",
                                                  style: Theme.of(context)
                                                      .appBarTheme
                                                      .titleTextStyle),
                                              const SizedBox(height: 10),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 25),
                                                decoration: BoxDecoration(
                                                  color: kGrey.withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                                child:
                                                    buildRoomTitleFormField(),
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 25),
                                                decoration: BoxDecoration(
                                                  color: kGrey.withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                                child:
                                                    buildRoomDescriptionFormField(),
                                              ),
                                              const SizedBox(height: 20),
                                              //create room button
                                              Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 25),
                                                decoration: BoxDecoration(
                                                  color: kBlue,
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      if (roomTitleController
                                                          .text
                                                          .trim()
                                                          .isNotEmpty) {}
                                                      formKey.currentState!
                                                          .save();

                                                      try {
                                                        createRoom(
                                                                roomName:
                                                                    roomTitleController
                                                                        .text,
                                                                description:
                                                                    roomDescriptionController
                                                                        .text)
                                                            .then((value) {
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      } catch (e) {
                                                        print(
                                                            "CREATE ROOM ERROR: $e");
                                                      }
                                                      // check if mounted
                                                      roomTitleController
                                                          .clear();
                                                      roomDescriptionController
                                                          .clear();
                                                    } else {}
                                                  },
                                                  child: Text("Create Room",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                        });
                  },
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              message: const Text('Create a new room with your friends'),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getUserRooms(authProvider.user!.uid),
        builder: (context, snapshot) {
          var rooms = snapshot.data ?? [];
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: 10.0,
                      ),
                      child: ListTile(
                        title: Container(
                          color: const Color.fromARGB(255, 208, 200, 200),
                          width: double.infinity,
                          height: 20.0,
                        ),
                        leading: Container(
                          color: Colors.white,
                          width: 50.0,
                          height: 50.0,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (rooms.isEmpty) {
            return const Center(
              child: Text(
                'Get started by creating a room',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              var chat = rooms[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: ListTile(
                  title: Text(
                    chat['roomName'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    chat['description'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupChatsScreen(
                          roomId: chat['id'],
                          roomName: chat['roomName'],
                          roomDescription: chat['description'],
                          roomImage: chat['roomImage'],
                          roomMembers: chat['members'],
                        ),
                      ),
                    );
                  },
                  leading: chat['roomImage'] != null
                      ? chat['roomImage'] != ""
                          ? Container(
                              color: Colors.white,
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(chat['roomImage']),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[400]!,
                                ),
                                shape: BoxShape.circle,
                                //   color: Colors.grey,
                                // color: Colors.white,
                              ),
                              child: const Center(
                                child: Icon(Icons.group),
                              ),
                            )
                      : Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: const Center(
                            child: Icon(Icons.group),
                          ),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
