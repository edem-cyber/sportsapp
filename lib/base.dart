import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/home/home.dart';
import 'package:sportsapp/screens/leagues/leagues.dart';
import 'package:sportsapp/screens/picks/picks.dart';
import 'package:sportsapp/screens/search/search.dart';

class Base extends StatefulWidget {
  static String routeName = "/base";
  const Base({Key? key}) : super(key: key);
  //scroll controller

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  final ScrollController scrollController = ScrollController();
  var _currentIndex = 0;

  // int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[];

  // @override
  // void initState() {
  //   _widgetOptions = <Widget>[
  //     // News(
  //     //   scrollController: ScrollController(),
  //     // ),
  //     Text('Profile'),
  //   ];
  // }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 0 && scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }

    // if (index == 0 && scrollController.hasClients) {
    //   scrollController.animateTo(
    //     0,
    //     duration: const Duration(milliseconds: 500),
    //     curve: Curves.easeOut,
    //   );
    // }
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
      {
        'title': 'Search',
        'icon': 'assets/icons/search.svg',
        // 'activeIcon': Icon(Icons.favorite_border_outlined),
        'page': Search(),
      },
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
        'page': const Leagues(),
      },
    ];

    //initialize the size config
    return WillPopScope(
      //forbidden swipe in iOS(my ThemeData(platform: TargetPlatform.iOS,)
      onWillPop: () async {
        return false;
      },
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
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
            print("INDEX IS : $index");
            setState(
              () {
                if (_currentIndex == 0 &&
                    scrollController.hasClients &&
                    scrollController.offset != 0) {
                  scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                }
                //check if coming from a different page
                _currentIndex = index;
              },
            );
          },
        ),
        tabBuilder: (BuildContext context, int index) {
          return pages[index]['page'];
        },
      ),
    );
  }
}

// Consumer<ThemeProvider>(
//           builder: (context, ThemeProvider themeProvider, child) {


  // Consumer<ThemeProvider>(
  //         builder: (context, themeProvider, _) => CupertinoTabBar(
  //           currentIndex: _currentIndex,
  //           iconSize: 30,
  //           height: 60,
  //           activeColor: kWhite,
  //           inactiveColor: kLightBlue,
  //           backgroundColor: themeProvider.isDarkMode ? kBlack500 : kBlue,
  //           onTap: (index) => setState(() {
  //             _currentIndex = index;
  //           }),
  //           // type: BottomNavigationBarType.fixed,
  //           items: pages
  //               .map(
  //                 (page) => BottomNavigationBarItem(
  //                   icon: SvgPicture.asset(
  //                     page['icon'],
  //                     color: kLightBlue,
  //                     height: (30),
  //                   ),
  //                   activeIcon: SvgPicture.asset(
  //                     page['icon'],
  //                     height: (30),
  //                   ),
  //                   label: "${page['title']}",
  //                 ),
  //               )
  //               .toList(),
  //         ),
  //       ),