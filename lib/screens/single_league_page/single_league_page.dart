import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/single_league_page/widgets/table_screen.dart';
// import 'package:sportsapp/screens/friends_pasge/widgets/body.dart';

class LeaguePage extends StatefulWidget {
  //routename
  static const routeName = '/league-page';
  const LeaguePage({Key? key}) : super(key: key);

  @override
  State<LeaguePage> createState() => _LeaguePageState();
}

class _LeaguePageState extends State<LeaguePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: true,
        // title: Text("LeaguePage"),
        actions: [
          SvgPicture.asset(
            "assets/icons/settings.svg",
            color: kBlack,
            width: 20,
          ),
          const SizedBox(
            width: 15,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kTextTabBarHeight),
          child: Container(
            // height: 0,
            padding: const EdgeInsets.only(left: 25, bottom: 0),
            width: MediaQuery.of(context).size.width,
            child: TabBar(
              tabs: const [
                Tab(
                  text: 'Friends',
                ),
                Tab(
                  text: 'Requests',
                ),
              ],
              splashFactory: NoSplash.splashFactory,
              labelColor: themeProvider.isDarkMode ? kWhite : kBlack,
              unselectedLabelColor: themeProvider.isDarkMode ? kWhite : kBlack,
              indicatorColor: kBlue,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 3,
              unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
              labelStyle: Theme.of(context).tabBarTheme.labelStyle,
              isScrollable: true,
              labelPadding:
                  const EdgeInsets.only(left: 10, right: 30, bottom: 0),
              controller: tabController,
            ),
          ),
        ),
      ),
      // body: Body(
      //   tabController: tabController,
      // ),
      // body: const TableScreen(code: ""),
    );
  }
}
