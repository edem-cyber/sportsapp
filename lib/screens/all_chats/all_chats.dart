import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
// import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/all_chats/widgets/body.dart';

class AllChats extends StatefulWidget {
  static const String routeName = '/all_chats';
  const AllChats({Key? key}) : super(key: key);

  @override
  State<AllChats> createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var tabController = TabController(length: 2, vsync: this);
    // var authProvider = Provider.of<AuthProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
          title: const Text('All Chats'),
          elevation: 1,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kTextTabBarHeight),
            child: TabBar(
              controller: tabController,
              splashFactory: NoSplash.splashFactory,
              labelColor: themeProvider.isDarkMode ? kWhite : kBlack,
              unselectedLabelColor: themeProvider.isDarkMode ? kWhite : kBlack,
              indicatorColor: kBlue,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2,
              unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
              labelStyle: Theme.of(context).tabBarTheme.labelStyle,
              isScrollable: true,
              labelPadding:
                  const EdgeInsets.only(left: 15, right: 30, bottom: 0),
              tabs: const [
                Tab(
                  text: "Chats",
                ),
                Tab(
                  text: "Rooms",
                ),
              ],
            ),
          )),
      body: Body(
        tabController: tabController,
      ),
    );
  }
}
