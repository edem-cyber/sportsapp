import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/direct_message_page/direct_message_page.dart';
import 'package:sportsapp/screens/new_room_page/new_room_page.dart';

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

    Stream<List<Map<String, dynamic>>> chatsStream(String currentUserUid) {
      return FirebaseFirestore.instance
          .collection('Chats')
          .where('members', arrayContains: currentUserUid)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
          );
    }

    var authProvider = Provider.of<AuthProvider>(context, listen: false);

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
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NewRoomPage(),
                        fullscreenDialog: true,
                      ),
                    );
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
        stream: chatsStream(authProvider.user!.uid),
        builder: (context, snapshot) {
          var chats = snapshot.data ?? [];
          if (!snapshot.hasData ||
              snapshot.hasError ||
              snapshot.connectionState == ConnectionState.waiting) {
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
          } else if (chats.isEmpty) {
            return const Center(
              child: Text(
                'No Chats',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              var chat = chats[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: authProvider.getProfileData(
                    id: chat['members'][0] == authProvider.user!.uid
                        ? chat['members'][1]
                        : chat['members'][0],
                  ),
                  builder: (context, snapshot) {
                    var user = snapshot.data != null
                        ? snapshot.data!.data()
                        : {
                            'displayName': 'User',
                            'username': 'User',
                            'photoURL':
                                'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                          };
                    if (!snapshot.hasData ||
                        snapshot.connectionState == ConnectionState.waiting) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 22,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(child: CupertinoActivityIndicator());
                    }
                    if (snapshot.hasData) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => DirectMessagePage(
                                id: chat['members'][0] == authProvider.user!.uid
                                    ? chat['members'][1]
                                    : chat['members'][0],
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: CachedNetworkImageProvider(
                            user!['photoURL'] ??
                                'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                          ),
                        ),
                        title: Text(
                          user['displayName'] ?? user['username'] ?? 'User',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          chat['lastMessageTime'] != null
                              ? DateTime.fromMillisecondsSinceEpoch(
                                      chat['lastMessageTime']!.seconds * 1000)
                                  .toLocal()
                                  .toString()
                                  .substring(0, 16)
                              : '',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
