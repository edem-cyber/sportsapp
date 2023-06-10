import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sportsapp/providers/AuthProvider.dart';
// import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/all_chats/tabs/chats_tab.dart';
import 'package:sportsapp/screens/all_chats/tabs/group_chats_tab.dart';

class Body extends StatefulWidget {
  final TabController tabController;
  const Body({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // var themeProvider = Provider.of<ThemeProvider>(context);

    // var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scrollbar(
      controller: scrollController,
      child: SafeArea(
        child: ListView(
          controller: scrollController,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: TabBarView(
                controller: widget.tabController,
                children: const [
                  ChatsTab(),
                  GroupChatsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
