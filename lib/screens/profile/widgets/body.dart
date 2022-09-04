import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context, listen: true);
    var navigationService = Provider.of<NavigationService>(context);
    var tabController = TabController(length: 3, vsync: this);
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
            placeholder: (context, url) =>
                const Center(child: CupertinoActivityIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            children: [
              Text(
                "Larry Mills",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text("@larrymillz", style: Theme.of(context).textTheme.bodySmall!
                  // .copyWith(color: kBlack),
                  ),
              Text("Joined January 2014",
                  style: Theme.of(context).textTheme.bodySmall!
                  // .copyWith(color: ),
                  ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "We move regardless",
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
                        navigationService.openFullScreenDialog(const EditProfile());
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
                        color: kBlue, borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(7),
                    child: InkWell(
                      onTap: () {
                        navigationService.nagivateRoute(Settings.routeName);
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
                          .copyWith(color: kBlack, fontWeight: FontWeight.bold),
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
