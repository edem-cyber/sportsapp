import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/screens/home/home.dart';
import 'package:sportsapp/screens/profile/profile_screen.dart';

class Base extends StatefulWidget {
  static String routeName = "/base";
  const Base({Key? key}) : super(key: key);

  @override
  State<Base> createState() => _BaseState();
}

class _BaseState extends State<Base> {
  var _currentIndex = 0;
  final List pages = [
    {
      'title': 'News',
      'icon': const Icon(Icons.stacked_line_chart_rounded),
      // 'activeIcon': 'assets/icons/home_active.svg',
      'page': const News(),
    },
    {
      'title': 'Chat',
      'icon': const Icon(Icons.chat_bubble_outlined),
      // 'activeIcon': Icon(Icons.favorite_border_outlined),
      'page': const News(),
    },
    {
      'title': 'Profile',
      'icon': const Icon(Icons.person_outline),
      // 'activeIcon': 'assets/icons/profile_active.svg',
      'page': const ProfileScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    //initialize the size config
    return WillPopScope(
      //forbidden swipe in iOS(my ThemeData(platform: TargetPlatform.iOS,)
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(child: pages[_currentIndex]['page']),
        bottomNavigationBar: CupertinoTabBar(
          iconSize: 30,
          height: 60,
          activeColor: kBlue,
          // selectedItemColor: kTertiaryColor,
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          // backgroundColor: kWhite,
          onTap: (index) => setState(() {
            _currentIndex = index;
          }),
          // type: BottomNavigationBarType.fixed,
          items: pages
              .map(
                (page) => BottomNavigationBarItem(
                  // activeIcon: SvgPicture.asset(
                  //   page['activeIcon'],
                  //   height: getProportionateScreenHeight(30),
                  // ),
                  icon: page['icon'],
                  // label: page['title'],
                ),
              )
              .toList(),
          currentIndex: _currentIndex,
        ),
      ),
    );
  }
}
