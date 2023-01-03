import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/comments_page/comments_page.dart';
import 'package:sportsapp/screens/picks/widgets/room.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // late bool _loading;
  // var newslist = [];

  @override
  Widget build(BuildContext context) {
    // var getPosts = Provider.of<AuthProvider>(context, listen: false).getPosts();
    // TabController tabController = TabController(length: 3, vsync: this);

    //tab bar controller
    var themeProvider = Provider.of<ThemeProvider>(context);
    var navigationService = Provider.of<NavigationService>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    var getAllPicks = authProvider.getAllPicks();

    // final postModel = Provider.of<DataClass>(context);
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: getAllPicks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No Picks"));
        }

        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                dismissThresholds: const {
                  DismissDirection.startToEnd: 0.8,
                  DismissDirection.endToStart: 0.2,
                },
                key: UniqueKey(),
                confirmDismiss: (direction) {
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                            title: const Text("Confirm"),
                            content: const Text("Delete this Pick?"),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                onPressed: () {
                                  setState(() {
                                    authProvider.deletePick(
                                        id: snapshot.data!.docs[index].id);
                                  });
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
                          ));
                },
                background: Container(
                  color: kWarning,
                  child: const Icon(Icons.delete),
                ),
                child: Room(
                    onTap: () {
                      // navigationService.nagivateRoute(CommentsPage.routeName);
                      //navigate using material page route
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CommentsPage(
                          id: snapshot.data!.docs[index].id,
                        ),
                      ));
                    },
                    desc: snapshot.data!.docs[index]['desc'],
                    title: snapshot.data!.docs[index]['title'],
                    comments: "$index",
                    likes: "$index",
                    isRead: true),
              );
            },
          );
        }

        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }
}
