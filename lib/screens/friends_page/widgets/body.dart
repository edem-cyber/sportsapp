import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
// import 'package:sportsapp/providers/ThemeProvider.dart';
// import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/widgets/friend.dart';
import 'package:sportsapp/screens/friends_page/widgets/friend_request.dart';
import 'package:sportsapp/screens/profile/profile.dart';

class Body extends StatefulWidget {
  final TabController tabController;
  const Body({Key? key, required this.tabController}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // var themeProvider = Provider.of<ThemeProvider>(context);
    // var navigationService = Provider.of<NavigationService>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);

    Future<List<DocumentSnapshot>> getUsersByUids() async {
      List<DocumentSnapshot> users = [];
      try {
        List<String> userreq = await authProvider.getFriendRequests();
        for (String uid in userreq) {
          DocumentSnapshot user = await FirebaseFirestore.instance
              .collection("Users")
              .doc(uid)
              .get();
          users.add(user);
        }
      } catch (error) {
        debugPrint(error.toString());
      }
      return users;
    }

    Future<List<DocumentSnapshot>> getUidsOfFriends() async {
      List<DocumentSnapshot> users = [];
      try {
        List<String> userreq = await authProvider.getFriends();
        for (String uid in userreq) {
          DocumentSnapshot user = await FirebaseFirestore.instance
              .collection("Users")
              .doc(uid)
              .get();
          users.add(user);
        }
      } catch (error) {
        debugPrint(error.toString());
      }
      return users;
    }

    // Future<List<String>> getFriendRequests = authProvider.getFriendRequests();

    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            // viewportFraction: 0.8,
            // controller: tabController,
            children: [
              FutureBuilder<List<DocumentSnapshot>>(
                initialData: const [],
                future: getUidsOfFriends(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.hasError) {
                    return const Center(child: CupertinoActivityIndicator());
                  } else if (snapshot.hasData) {
                    List<DocumentSnapshot> friends = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      itemCount: friends.length,
                      itemBuilder: (BuildContext context, int index) {
                        debugPrint("$index");
                        return Friend(
                          name: friends[index]["displayName"],
                          username: friends[index]["username"],
                          desc: friends[index]["bio"],
                          image: friends[index]["photoURL"],
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile(
                                          id: friends[index].id,
                                        )));
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No friend requests"));
                  }
                },
              ),
              FutureBuilder<List<DocumentSnapshot>>(
                initialData: const [],
                future: getUsersByUids(),
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
                        debugPrint("$index");

                        return FriendRequest(
                          image: friendRequests[index]["photoURL"],
                          name: friendRequests[index]["displayName"],
                          bio: friendRequests[index]["bio"],
                          username: friendRequests[index]["username"],
                          onTap1: () {
                            authProvider
                                .acceptFriendRequest(friendRequests[index].id);
                            setState(() {
                              friendRequests.removeAt(index);
                            });
                          },
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text("No friend requests"));
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
