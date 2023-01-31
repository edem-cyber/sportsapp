import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/comments_page/comments_page.dart';
import 'package:sportsapp/screens/picks/widgets/room.dart';

class Body extends StatefulWidget {
  int? reply;
  final Stream<QuerySnapshot<Map<String, dynamic>>> searchResults;
  Body({
    Key? key,
    required this.searchResults,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // late bool _loading;
  // var newslist = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int replyCount = widget.reply ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var navigationService = Provider.of<NavigationService>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    var getAllPicks = authProvider.getAllPicks();
    // isAdmin
    var isAdmin = authProvider.isAdmin();
    final FirebaseFirestore _dataBase = FirebaseFirestore.instance;

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: widget.searchResults,
      builder: (context, snapshot) {
        var allPicksFuture = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            allPicksFuture!.docs.isEmpty) {
          return const Center(child: Text("No Picks"));
        }

        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: allPicksFuture.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder<bool>(
                future: isAdmin,
                builder: (context, snapshot) {
                  bool futureVar = snapshot.data ?? false;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Room(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CommentsPage(
                                  id: allPicksFuture.docs[index].id,
                                ),
                              ),
                            );
                          },
                          desc: allPicksFuture.docs[index]['desc'],
                          title: allPicksFuture.docs[index]['title'],
                          id: allPicksFuture.docs[index].id,
                          isRead: true,
                        ),
                      ),
                    );
                  } else if (futureVar == true) {
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      behavior: HitTestBehavior.translucent,
                      dragStartBehavior: DragStartBehavior.start,
                      dismissThresholds: const {
                        DismissDirection.endToStart: 0.2,
                      },
                      key: Key(allPicksFuture.docs[index].id),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          return showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: const Text("Confirm"),
                              content: const Text("Delete this Pick?"),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  onPressed: () {
                                    setState(
                                      () {
                                        authProvider.deletePick(
                                            id: allPicksFuture.docs[index].id);
                                      },
                                    );
                                    navigationService.goBack();
                                  },
                                  child: const Text("Confirm"),
                                ),
                                CupertinoDialogAction(
                                  onPressed: () {
                                    navigationService.goBack();
                                    return;
                                  },
                                  child: const Text("Cancel"),
                                )
                              ],
                            ),
                          );
                        }
                      },
                      background: Container(
                        color: kWarning,
                        child: const Icon(Icons.delete),
                      ),
                      child: Room(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommentsPage(
                                id: allPicksFuture.docs[index].id,
                              ),
                            ),
                          );
                        },
                        desc: allPicksFuture.docs[index]['desc'],
                        title: allPicksFuture.docs[index]['title'],
                        id: allPicksFuture.docs[index].id,
                        isRead: true,
                      ),
                    );
                  }
                  return Room(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsPage(
                            id: allPicksFuture.docs[index].id,
                          ),
                        ),
                      );
                    },
                    desc: allPicksFuture.docs[index]['desc'],
                    title: allPicksFuture.docs[index]['title'],
                    id: allPicksFuture.docs[index].id,
                    isRead: true,
                  );
                },
              );
            },
          );
        }

        return const Center(child: CupertinoActivityIndicator());
      },
    );
  }
}
