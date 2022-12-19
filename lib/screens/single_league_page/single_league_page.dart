import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/single_league_page/tabs/fixtures/fixtures.dart';
import 'package:sportsapp/screens/single_league_page/tabs/league_table.dart';

class LeagueDetailsScreen extends StatefulWidget {
  //routename
  static const routeName = '/single-league-page';
  final String? code;
  const LeagueDetailsScreen({Key? key, this.code}) : super(key: key);

  @override
  State<LeagueDetailsScreen> createState() => _LeaguePageState();
}

class _LeaguePageState extends State<LeagueDetailsScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    print("CODE: ${widget.code}");
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    TabController tabController = TabController(length: 2, vsync: this);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          'League Details',
        ),
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
