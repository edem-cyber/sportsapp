import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/edit_profile/edit_profile.dart';
import 'package:sportsapp/screens/profile/tabs/likes.dart';
import 'package:sportsapp/screens/profile/tabs/media.dart';
import 'package:sportsapp/screens/profile/tabs/rooms.dart';
import 'package:sportsapp/screens/settings/settings.dart';

class Body extends StatefulWidget {
  Body({Key? key, required this.id}) : super(key: key);
  String id;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {
  Map<String, dynamic> userData = {};
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    var navigationService = Provider.of<NavigationService>(context);
    var tabController = TabController(length: 3, vsync: this);
    var userProfile = authProvider.getProfileData(id: widget.id);
    var userData = authProvider.getUserData();

    //convert timesstamp to formatted date
    formattedDate(Timestamp timestamp) {
      var date = timestamp.toDate();
      DateFormat dateFormat = DateFormat().add_yMMM();
      return dateFormat.format(date);
    }

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: userProfile,
      builder: (context, snapshot) {
        var profile = snapshot.data;

        if (snapshot.data == null) {
          return SizedBox(
            // width: size.width,
            // height: size.height,
            child: Center(
              child: Text(
                'No bookmarks',
                style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: userData,
            builder: (context, snapshot) {
              var currentUser = snapshot.data;
              if (snapshot.data == null ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else if (snapshot.hasData) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      CachedNetworkImage(
                        imageUrl: authProvider.user!.uid == widget.id
                            ? currentUser!['photoURL']
                            : profile!['photoURL'],
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: const CircleAvatar(
                              radius: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Text(
                            authProvider.user!.uid == widget.id
                                ? currentUser!['displayName']
                                : profile!['displayName'],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                              authProvider.user!.uid == widget.id
                                  ? currentUser!['username']
                                  : profile!['username'],
                              style: Theme.of(context).textTheme.bodySmall!),
                          Text(
                              formattedDate(authProvider.user!.uid == widget.id
                                  ? currentUser!['createdAt']
                                  : profile!['createdAt']),
                              style: Theme.of(context).textTheme.bodySmall!),
                          const SizedBox(
                            height: 10,
                          ),
                          authProvider.user!.uid == widget.id
                              ? Text(
                                  currentUser!['bio'].toString().isEmpty
                                      ? ''
                                      : currentUser['bio'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                )
                              : Text(
                                  profile!['bio'].toString().isEmpty
                                      ? ''
                                      : profile['bio'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //  check if id is widget id then show edit profile button
                              authProvider.user!.uid == widget.id
                                  ? OutlinedButton(
                                      onPressed: () {
                                        navigationService.openFullScreenDialog(
                                            const EditProfile());
                                      },
                                      style: OutlinedButton.styleFrom(
                                        primary: kBlue,
                                        shape: const StadiumBorder(),
                                        side: const BorderSide(color: kBlue),
                                      ),
                                      child: Text(
                                        "Edit Profile",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                      // borderSide: BorderSide(color: Colors.blue),
                                      // shape: StadiumBorder(),
                                      )
                                  : OutlinedButton(
                                      onPressed: () {
                                        // navigationService.openFullScreenDialog(
                                        //   const EditProfile(),
                                        // );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        // primary: kWhite,
                                        backgroundColor: kBlue,
                                        shape: const StadiumBorder(),
                                        side: const BorderSide(color: kWhite),
                                      ),
                                      child: Text(
                                        "Add Friend",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: kWhite,
                                                fontWeight: FontWeight.bold),
                                      )
                                      // borderSide: BorderSide(color: Colors.blue),
                                      // shape: StadiumBorder(),
                                      ),
                              const SizedBox(
                                width: 3,
                              ),

                              authProvider.user!.uid == widget.id
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: kBlue,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: const EdgeInsets.all(7),
                                      child: InkWell(
                                        onTap: () {
                                          navigationService.nagivateRoute(
                                              SettingsPage.routeName);
                                        },
                                        child: SvgPicture.asset(
                                          "assets/icons/x.svg",
                                          color: kWhite,
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text.rich(
                            TextSpan(
                              //align children center
                              children: <InlineSpan>[
                                TextSpan(
                                  text: "2198",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: kBlack,
                                          fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: " Friends",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: kBlack),
                                ),
                              ],
                            ),
                            // textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TabBar(
                        controller: tabController,
                        splashFactory: NoSplash.splashFactory,
                        labelColor: themeProvider.isDarkMode ? kWhite : kBlack,
                        unselectedLabelColor:
                            themeProvider.isDarkMode ? kWhite : kBlack,
                        indicatorColor: kBlue,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 3,
                        unselectedLabelStyle:
                            Theme.of(context).textTheme.bodySmall,
                        labelStyle: Theme.of(context).tabBarTheme.labelStyle,
                        isScrollable: true,
                        labelPadding: const EdgeInsets.only(
                            left: 15, right: 30, bottom: 0),
                        tabs: const [
                          Tab(
                            text: "Likes",
                          ),
                          Tab(
                            text: "Rooms",
                          ),
                          Tab(
                            text: "Media",
                          )
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: TabBarView(
                          controller: tabController,
                          // viewportFraction: 0.8,
                          // controller: tabController,
                          children: [
                            LikesTab(
                              id: widget.id,
                            ),
                            RoomsTab(),
                            MediaTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else if (currentUser!['likes'] == 0) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              return const Center(child: CupertinoActivityIndicator());
            },
          );
        }

        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }
}
