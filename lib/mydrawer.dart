import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
// import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/all_chats/all_chats.dart';
import 'package:sportsapp/screens/bookmarks/bookmarks.dart';
import 'package:sportsapp/screens/friends_page/friends_page.dart';
import 'package:sportsapp/screens/profile/profile.dart';
import 'package:sportsapp/screens/settings/settings.dart';
import 'package:sportsapp/screens/videos/videos.dart';
import 'package:sportsapp/widgets/app_dialog.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // var themeProvder = Provider.of<ThemeProvider>(context, listen: true);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    var navigationService =
        Provider.of<NavigationService>(context, listen: false);

    void navigateFromDrawer(String routeName) {
      navigationService.goBack();
      navigationService.nagivateRoute(routeName);
    }

    var userDataStream = authProvider.getUserData();

    return Drawer(
      backgroundColor: kBlue,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                          future: userDataStream,
                          builder: (context, snapshot) {
                            var user = snapshot.data != null
                                ? snapshot.data!.data()
                                : {
                                    'displayName': 'USER',
                                    'username': 'USER',
                                    'photoURL':
                                        'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png',
                                    'email': 'USER',
                                    'bio': 'USER',
                                    'password': "USER",
                                    'lastSeen': DateTime.now(),
                                    'createdAt': DateTime.now(),
                                    'liked_posts': [],
                                    'isAdmin': false,
                                  };
                            if (!snapshot.hasData || snapshot.error != null) {
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                      user!['displayName'] ?? 'Error',
                                      style: const TextStyle(
                                          color: kWhite, fontSize: 12),
                                    ),
                                    accountEmail: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['username'],
                                          style: const TextStyle(
                                            color: kWhite,
                                            fontSize: 12,
                                          ),
                                        ),
                                        FutureBuilder<List>(
                                            initialData: const [],
                                            future: authProvider.getFriends(),
                                            builder: (context, snapshot) {
                                              var friends = snapshot.data ?? [];
                                              return Text.rich(
                                                TextSpan(
                                                  //align children center
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                      text: snapshot.hasData
                                                          ? friends.length
                                                              .toString()
                                                          : "0",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: kWhite),
                                                    ),
                                                    TextSpan(
                                                      // if more than 1 friend, add an 's'
                                                      text: snapshot.hasData &&
                                                              friends.length > 1
                                                          ? " friends"
                                                          : " friend",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: kWhite),
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
                                    currentAccountPicture: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: user['photoURL'] ??
                                          AppImage.defaultProfilePicture2,
                                      imageBuilder: (context, imageProvider) =>
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
                      // ListTile(
                      //   contentPadding:
                      //       const EdgeInsets.symmetric(horizontal: 35),
                      //   dense: true,
                      //   leading: SvgPicture.asset(
                      //     "assets/icons/comment.svg",
                      //     height: 20,
                      //   ),
                      //   title: const Text(
                      //     "Topics",
                      //     style: TextStyle(color: kWhite),
                      //   ),
                      //   onTap: () {},
                      // ),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 35),
                        dense: true,
                        leading: SvgPicture.asset("assets/icons/settings.svg",
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
                              navigationService.goBack();
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
    );
  }
}
