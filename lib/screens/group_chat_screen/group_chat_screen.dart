import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/widgets/friend.dart';
import 'package:sportsapp/screens/group_chat_screen/widgets/body.dart';

class GroupChatsScreen extends StatefulWidget {
  final String? roomName, roomId, roomDescription, roomImage;
  final List<String>? roomMembers;
  const GroupChatsScreen(
      {super.key,
      this.roomName,
      this.roomId,
      this.roomDescription,
      this.roomImage,
      this.roomMembers});

  @override
  State<GroupChatsScreen> createState() => _GroupChatsScreenState();
}

class _GroupChatsScreenState extends State<GroupChatsScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var profile = authProvider.getProfileData(id: authProvider.user!.uid);
    mymodal() {
      return showModalBottomSheet(
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
          builder: (BuildContext context) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      Text(
                        "Group details",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        "${widget.roomName}",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                            ),
                      ),
                      Text(
                        "${widget.roomDescription}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        "Members",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: kBlue),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.roomMembers!.length,
                        itemBuilder: (context, index) {
                          // String uid = widget.roomMembers![index];
                          return FutureBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
                            future: authProvider.getProfileData(
                                id: widget.roomMembers![index]),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Map<String, dynamic> userData =
                                    snapshot.data!.data()!;
                                // Display user information in a widget
                                return Friend(
                                  name: userData['displayName'],
                                  desc: userData['bio'],
                                  image: userData['photoURL'],
                                  username: userData['username'],
                                  onTap: () {},
                                );
                              } else {
                                // Show a loading indicator while waiting for data
                                return const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 3,
                                  ),
                                  child: CupertinoActivityIndicator(),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          actions: [
            widget.roomImage != null && widget.roomImage != ''
                ? GestureDetector(
                    onTap: (() {
                      // open cupertino modal and show details
                      mymodal();
                    }),
                    child: CachedNetworkImage(
                      imageUrl: widget.roomImage!,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => const SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  )
                : const SizedBox(width: 40),
            GestureDetector(
              onTap: (() {
                mymodal();
              }),
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: CircleAvatar(
                  foregroundColor:
                      themeProvider.isDarkMode ? Colors.white : kBlue,
                  child: const Icon(Icons.group),
                ),
              ),
            )
          ],
          title: GestureDetector(
            onTap: (() {
              mymodal();
            }),
            child: Text(
              widget.roomName!,
            ),
          )),
      body: Body(
        roomId: widget.roomId,
        roomName: widget.roomName,
        roomDescription: widget.roomDescription,
        roomImage: widget.roomImage,
        roomMembers: widget.roomMembers,
      ),
    );
  }
}
