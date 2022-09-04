import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
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

    // final postModel = Provider.of<DataClass>(context);
    return ListView.builder(
      // separatorBuilder: ((context, index) {
      //   return const Divider(color: kGrey);
      // }),
      itemCount: 9,
      itemBuilder: (BuildContext context, int index) {
        return Room(
            onTap: () {
              navigationService.nagivateRoute(CommentsPage.routeName);
            },
            desc:
                "Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins.",
            title: "MESSI Leave Barca",
            comments: "$index",
            likes: "$index",
            isRead: true);
      },
    );
  }
}
