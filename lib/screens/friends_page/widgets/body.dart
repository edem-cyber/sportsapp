import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            // viewportFraction: 0.8,
            // controller: tabController,
            children: [
              Container(
                // padding: EdgeInsets.symmetric(vertical: 20),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20),
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
              ),
              Container(
                // padding: EdgeInsets.symmetric(vertical: 20),
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return FriendRequest(
                      name: 'Larry Mills',
                      desc:
                          '$index Father, husband & music. Going thru bariatric. Boston U & St Edward grad Browns Cavs Guardian Penguins Terriers Buckeyes',
                      username: '@LarryMillz',
                      // friend: friend,
                    );
                  },
                ),
              ),
              // Trending(),
              // Videos(),
            ],
          ),
        ),
      ],
    );
  }
}
