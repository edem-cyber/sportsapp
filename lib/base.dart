import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/mydrawer.dart';
import 'package:sportsapp/screens/home/home.dart';
import 'package:sportsapp/screens/leagues/leagues.dart';
import 'package:sportsapp/screens/picks/picks.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class Base extends StatefulWidget {
  static String routeName = "/base";
  const Base({Key? key}) : super(key: key);

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  final ScrollController scrollController = ScrollController();
  //change active page
  var _currentIndex = 1;

  showPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List pages = [
      {
        'title': 'News',
        'icon': 'assets/icons/home.svg',
        // 'icon': const Icon(Icons.stacked_line_chart_rounded),
        // 'activeIcon': 'assets/icons/home_active.svg',
        'page': News(
          // scrollController: ScrollController(),
          scrollController: scrollController,
        ),
      },
      // {
      //   'title': 'Search',
      //   'icon': 'assets/icons/search.svg',
      //   // 'activeIcon': Icon(Icons.favorite_border_outlined),
      //   'page': Search(),
      // },
      {
        'title': 'Picks',
        'icon': 'assets/icons/picks.svg',
        // 'activeIcon': 'assets/icons/profile_active.svg',
        'page': const Picks(),
      },
      {
        'title': 'Leagues',
        'icon': 'assets/icons/leagues.svg',
        // 'activeIcon': 'assets/icons/profile_active.svg',
        'page': const LeagueScreen(),
      },
    ];

    //initialize the size config
    return Scaffold(
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: const MyDrawer(),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages.map(
          (page) {
            return page['page'] as Widget;
          },
        ).toList(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: kBlue,
        iconSize: 30,
        currentIndex: _currentIndex,
        height: 60,
        activeColor: kWhite,
        inactiveColor: kLightBlue,
        items: pages
            .map(
              (page) => BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  page['icon'],
                  color: kLightBlue,
                  height: (30),
                ),
                activeIcon: SvgPicture.asset(
                  page['icon'],
                  height: (30),
                ),
                label: "${page['title']}",
              ),
            )
            .toList(),
        onTap: (index) {
          if (kDebugMode) {
            debugPrint("INDEX IS : $index");
          }

          showPage(index);
          // showPage(index);
        },
      ),
    );
  }
}
