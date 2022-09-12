import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/search/tabs/for_you.dart';
import 'package:sportsapp/screens/search/tabs/trending.dart';
import 'package:sportsapp/screens/single_league_page/tabs/fixtures/fixtures.dart';
import 'package:sportsapp/screens/single_league_page/tabs/league_table.dart';
// import 'package:sportsapp/screens/single_league_page/widgets/leaguestats.dart';
// import 'package:sportsapp/screens/friends_pasge/widgets/body.dart';

class LeaguePage extends StatefulWidget {
  //routename
  static const routeName = '/league-page';
  final String? code;
  const LeaguePage({Key? key, this.code}) : super(key: key);

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
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Premier League"),
        // actions: [
        // SvgPicture.asset(
        //   "assets/icons/settings.svg",
        //   color: kBlack,
        //   width: 20,
        // ),
        // const SizedBox(
        //   width: 15,
        // ),
        // ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kTextTabBarHeight),
          child: Container(
            // height: 0,
            padding: const EdgeInsets.only(left: 25, bottom: 0),
            width: MediaQuery.of(context).size.width,
            child: TabBar(
              tabs: const [
                Tab(
                  text: 'Table',
                ),
                Tab(
                  text: 'Fixtures',
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: tabController,
                // viewportFraction: 0.8,
                // controller: tabController,
                children: [
                  LeagueTable(
                    // code: '',
                    code: widget.code ?? '',
                  ),
                  FixturesTab(
                    // code: '',
                    code: widget.code ?? '',
                  ),
                  // const Trending(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
