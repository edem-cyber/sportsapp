import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/providers/navigation_service.dart';
import 'package:sportsapp/screens/edit_profile/edit_profile.dart';
import 'package:sportsapp/screens/privacy_policy/privacy_policy.dart';
import 'package:sportsapp/screens/settings/settings.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

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
    var userData = authProvider.getUserData();

    //convert timesstamp to formatted date
    formattedDate(Timestamp timestamp) {
      var date = timestamp.toDate();
      //format using intl package
      DateFormat dateFormat = DateFormat().add_yMMM();
      return dateFormat.format(date);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          CachedNetworkImage(
            imageUrl:
                authProvider.user!.photoURL ?? AppImage.defaultProfilePicture,
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image:
                    DecorationImage(image: imageProvider, fit: BoxFit.contain),
              ),
            ),
            placeholder: (context, url) => const Center(
              child: CupertinoActivityIndicator(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error retrieving data'),
                );
              }

              if (snapshot.hasData) {
                return Column(
                  children: [
                    Text(
                      snapshot.data!['display'],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(snapshot.data!['username'],
                        style: Theme.of(context).textTheme.bodySmall!
                        // .copyWith(color: kBlack),
                        ),
                    Text(formattedDate(snapshot.data!['createdAt']),
                        style: Theme.of(context).textTheme.bodySmall!
                        // .copyWith(color: ),
                        ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      snapshot.data!['bio'].toString().isEmpty
                          ? ''
                          : snapshot.data!['bio'],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                            onPressed: () {
                              navigationService
                                  .openFullScreenDialog(const EditProfile());
                            },
                            style: OutlinedButton.styleFrom(
                              primary: kBlue,
                              shape: const StadiumBorder(),
                              side: const BorderSide(color: kBlue),
                            ),
                            child: Text(
                              "Edit Profile",
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                            // borderSide: BorderSide(color: Colors.blue),
                            // shape: StadiumBorder(),
                            ),
                        const SizedBox(
                          width: 3,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: kBlue,
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.all(7),
                          child: InkWell(
                            onTap: () {
                              navigationService
                                  .nagivateRoute(SettingsPage.routeName);
                            },
                            child: SvgPicture.asset(
                              "assets/icons/x.svg",
                              color: kWhite,
                            ),
                          ),
                        )
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
                                    color: kBlack, fontWeight: FontWeight.bold),
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
                );
              }

              return Column(
                children: [
                  Shimmer(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey[300]!,
                        Colors.grey[100]!,
                        Colors.grey[300]!,
                      ],
                    ),
                    child: Container(
                      width: 200,
                      height: 20,
                      color: Colors.grey,
                    ),
                  )
                ],
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TabBar(
            controller: tabController,
            splashFactory: NoSplash.splashFactory,
            labelColor: themeProvider.isDarkMode ? kWhite : kBlack,
            unselectedLabelColor: themeProvider.isDarkMode ? kWhite : kBlack,
            indicatorColor: kBlue,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 3,
            unselectedLabelStyle: Theme.of(context).textTheme.bodySmall,
            labelStyle: Theme.of(context).tabBarTheme.labelStyle,
            isScrollable: true,
            labelPadding: const EdgeInsets.only(left: 15, right: 30, bottom: 0),
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
          )
        ],
      ),
    );
  }
}
