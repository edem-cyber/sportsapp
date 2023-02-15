import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/all_chats/all_chats.dart';
import 'package:sportsapp/screens/bookmarks/bookmarks.dart';
import 'package:sportsapp/screens/friends_page/friends_page.dart';
import 'package:sportsapp/screens/home/home.dart';
import 'package:sportsapp/screens/leagues/leagues.dart';
import 'package:sportsapp/screens/picks/picks.dart';
import 'package:sportsapp/screens/profile/profile.dart';
import 'package:sportsapp/screens/search/search.dart';
import 'package:sportsapp/screens/settings/settings.dart';
import 'package:sportsapp/screens/videos/videos.dart';
import 'package:sportsapp/widgets/app_dialog.dart';
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
  var _currentIndex = 2;

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
        'page': const LeagueScreen(),
      },
    ];

    var themeProvder = Provider.of<ThemeProvider>(context, listen: true);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    var _navigationService =
        Provider.of<NavigationService>(context, listen: false);

    void navigateFromDrawer(String routeName) {
      _navigationService.goBack();
      _navigationService.nagivateRoute(routeName);
    }

    var userDataStream = authProvider.getUserData();

    //initialize the size config
    return Scaffold(
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          backgroundColor: kBlue,
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              future: userDataStream,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.error != null) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: const CupertinoActivityIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: const CupertinoActivityIndicator(),
                                  );
                                }

                                if (snapshot.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: GestureDetector(
                                      //   navigateFromDrawer(Profile.routeName);
                                      onTap: () {
                                        navigateFromDrawer(Profile.routeName);
                                      },
                                      child: UserAccountsDrawerHeader(
                                        // onDetailsPressed: () {
                                        //   navigateFromDrawer(Profile.routeName);
                                        // },
                                        decoration:
                                            const BoxDecoration(color: kBlue),
                                        accountName: Text(
                                          snapshot.data!['displayName'] ??
                                              'Error',
                                          style: const TextStyle(
                                              color: kWhite, fontSize: 12),
                                        ),
                                        accountEmail: Column(
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data!['username'],
                                              style: const TextStyle(
                                                color: kWhite,
                                                fontSize: 12,
                                              ),
                                            ),
                                            FutureBuilder<List>(
                                                initialData: const [],
                                                future:
                                                    authProvider.getFriends(),
                                                builder: (context, snapshot) {
                                                  return Text.rich(
                                                    TextSpan(
                                                      //align children center
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text: snapshot.hasData
                                                              ? snapshot
                                                                  .data!.length
                                                                  .toString()
                                                              : "0",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      kWhite),
                                                        ),
                                                        TextSpan(
                                                          // if more than 1 friend, add an 's'
                                                          text: snapshot
                                                                      .hasData &&
                                                                  snapshot.data!
                                                                          .length >
                                                                      1
                                                              ? " friends"
                                                              : " friend",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      kWhite),
                                                        ),
                                                      ],
                                                    ),
                                                    // textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  );
                                                }),
                                          ],
                                        ),
                                        currentAccountPicture:
                                            CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl: snapshot
                                                  .data!['photoURL'] ??
                                              AppImage.defaultProfilePicture2,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            // width: 80.0,
                                            // height: 80.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: AssetImage(AppImage
                                                      .defaultProfilePicture2),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                        // decoration:
                                        // BoxDecoration(),
                                        // otherAccountsPictures: [
                                        //   CircleAvatar(
                                        //     backgroundImage: NetworkImage(
                                        //         'https://img.icons8.com/pastel-glyph/2x/user-male.png'),
                                        //     backgroundColor: Colors.white,
                                        //   ),
                                        // ],
                                      ),
                                    ),
                                  );
                                }

                                return const Center(
                                  child: Text("Error Retrieving Data"),
                                );
                              }),
                          ListTile(
                            // horizontalTitleGap: 222,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 35),
                            dense: true,
                            leading: SvgPicture.asset("assets/icons/user.svg",
                                height: 20),
                            title: const Text(
                              "Profile",
                              style: TextStyle(color: kWhite),
                            ),
                            onTap: () {
                              navigateFromDrawer(Profile.routeName);
                            },
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 35),
                            dense: true,
                            leading: SvgPicture.asset(
                              "assets/icons/comment.svg",
                              height: 20,
                            ),
                            title: const Text(
                              "Topics",
                              style: TextStyle(color: kWhite),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 35),
                            dense: true,
                            leading: SvgPicture.asset(
                                "assets/icons/settings.svg",
                                height: 20),
                            title: const Text(
                              "Friend Requests",
                              style: TextStyle(color: kWhite),
                            ),
                            onTap: () {
                              navigateFromDrawer(FriendsPage.routeName);
                            },
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 35),
                            dense: true,
                            leading: SvgPicture.asset("assets/icons/y.svg"),
                            title: const Text(
                              "Videos",
                              style: TextStyle(color: kWhite),
                            ),
                            onTap: () {
                              navigateFromDrawer(Videos.routeName);
                            },
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 35),
                            dense: true,
                            leading: SvgPicture.asset(
                              "assets/icons/bookmark.svg",
                              height: 20,
                            ),
                            title: const Text(
                              "Bookmarks",
                              style: TextStyle(color: kWhite),
                            ),
                            onTap: () {
                              navigateFromDrawer(Bookmarks.routeName);
                            },
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 35),
                            dense: true,
                            leading: SvgPicture.asset(
                              "assets/icons/x.svg",
                              height: 20,
                            ),
                            title: const Text(
                              "Settings",
                              style: TextStyle(color: kWhite),
                            ),
                            onTap: () {
                              navigateFromDrawer(SettingsPage.routeName);
                            },
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 35),
                            dense: true,
                            leading: SvgPicture.asset(
                              "assets/icons/chat_bubble.svg",
                              height: 20,
                              color: kWhite,
                            ),
                            title: const Text(
                              "All Chats",
                              style: TextStyle(color: kWhite),
                            ),
                            onTap: () {
                              navigateFromDrawer(AllChats.routeName);
                            },
                          ),
                          const Expanded(child: SizedBox()),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 35),
                            dense: true,
                            leading: const Icon(
                              Icons.exit_to_app,
                              color: kWhite,
                            ),
                            title: const Text(
                              "Logout",
                              style: TextStyle(color: kWhite),
                            ),
                            onTap: () {
                              confirmDialog(
                                context,
                                "Are you sure you want to sign out?",
                                "Yes",
                                "No",
                                () {
                                  authProvider.signOut();
                                },
                                () {
                                  _navigationService.goBack();
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
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
            print("INDEX IS : $index");
          }

          showPage(index);
          // showPage(index);
        },
      ),
      // tabBuilder: (BuildContext context, int index) {
      //   return pages[index]['page'];
      // },
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
