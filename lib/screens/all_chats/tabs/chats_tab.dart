import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/screens/direct_message_page/direct_message_page.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<ChatsTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    Stream<List<Map<String, dynamic>>> chatsStream(String currentUserUid) {
      return FirebaseFirestore.instance
          .collection('Chats')
          .where('members', arrayContains: currentUserUid)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => {
                      ...doc.data(),
                      'id': doc.id,
                    })
                .toList(),
          );
    }

    String formatDate(Timestamp timestamp) {
      final now = DateTime.now();
      final date = timestamp.toDate();
      final difference = now.difference(date);

      if (difference.inSeconds < 60) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        final formatter = DateFormat('MMM d, y');
        return formatter.format(date);
      }
    }

    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    // final List<DocumentSnapshot> lastMessages = await getLastMessages(userId);

    return StreamBuilder<List<Map<String, dynamic>>>(
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
            debugPrint("chats: $chats");
            String chatId = chats[index]["id"];
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
                        child: ListTile(
                            title: Container(
                              color: const Color.fromARGB(255, 208, 200, 200),
                              width: double.infinity,
                              height: 20.0,
                            ),
                            leading: const CircleAvatar(
                              radius: 25.0,
                            )),
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
                        user['displayName'] ?? user['username'] ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: FutureBuilder<DocumentSnapshot>(
                          future: authProvider.getLastMessageForChat(
                            chatId: chatId,
                          ),
                          builder: (context, message) {
                            var lastMessage = message.data;
                            if (!message.hasData ||
                                message.connectionState ==
                                    ConnectionState.waiting ||
                                lastMessage == null) {
                              return const SizedBox.shrink();
                            } else if (message.hasError) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.grey,
                                  width: 100.0,
                                  height: 10.0,
                                ),
                              );
                            } else if (message.hasData) {
                              return Row(
                                children: [
                                  Text(
                                    lastMessage['sender_Id'] ==
                                            authProvider.user!.uid
                                        ? 'You: '
                                        : '',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    lastMessage['content'].toString().substring(
                                          0,
                                          lastMessage['content']
                                                      .toString()
                                                      .length >
                                                  20
                                              ? 20
                                              : lastMessage['content']
                                                  .toString()
                                                  .length,
                                        ),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    lastMessage['timestamp'] != null
                                        ? formatDate(
                                            lastMessage['timestamp']!,
                                          )
                                        : '',
                                    style: const TextStyle(
                                      color: kBlue,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const CupertinoActivityIndicator();
                          }),
                    );
                  }
                  return const CupertinoActivityIndicator();
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
