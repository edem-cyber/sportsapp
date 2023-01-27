import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/friends_page/widgets/friend.dart';
import 'package:sportsapp/screens/friends_page/widgets/friend_request.dart';

class Body extends StatefulWidget {
  final TabController tabController;
  Body({Key? key, required this.tabController}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var navigationService = Provider.of<NavigationService>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);

    Stream<List<DocumentSnapshot>> getUsersByUids() {
      StreamController<List<DocumentSnapshot>> streamController =
          StreamController();
      List<DocumentSnapshot> users = [];
      authProvider.getFriendRequests().then((userreq) {
        try {
          for (String uid in userreq) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(uid)
                .get()
                .then((user) {
              users.add(user);
              streamController.add(users);
            });
          }
        } catch (error) {
          streamController.addError(error);
        }
      });
      return streamController.stream;
    }

    Future<List<String>> getFriendRequests = authProvider.getFriendRequests();

    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            // viewportFraction: 0.8,
            // controller: tabController,
            children: [
              ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return Friend(
                    name: 'Larry Mills',
                    desc:
                        '$index Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins Terriers Buckeyes',
                    username: '@LarryMillz',
                    // friend: friend,
                  );
                },
              ),
              StreamBuilder<List<DocumentSnapshot>>(
                  stream: getUsersByUids(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.hasError) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (snapshot.hasData) {
                      List<DocumentSnapshot> friendRequests = snapshot.data!;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        itemCount: friendRequests.length,
                        itemBuilder: (BuildContext context, int index) {
                          print(index);
                          return FriendRequest(
                            image: friendRequests[index]["photoURL"],
                            name: friendRequests[index]["displayName"],
                            bio: friendRequests[index]["bio"],
                            username: friendRequests[index]["username"],
                            onTap1: () {
                              authProvider.acceptFriendRequest(
                                  friendRequests[index].id);
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No friend requests"));
                    }
                  }),
            ],
          ),
        ),
      ],
    );
  }
}
