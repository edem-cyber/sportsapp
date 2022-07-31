import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/search/widgets/body.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);
  static const String routeName = '/search';

  late TabController tabController;
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context);
    TabController tabController = TabController(length: 3, vsync: this);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
            child: CircleAvatar(
              // ignore: prefer_if_null_operators
              backgroundImage: NetworkImage(authProvider.user!.photoURL ??
                  AppImage.defaultProfilePicture),
              radius: 15,
            ),
          ),
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 0, right: 20, top: 0, bottom: 0),
              child: CircleAvatar(
                // ignore: prefer_if_null_operators
                // backgroundImage: NetworkImage(authProvider.user!.photoURL ??
                //     AppImage.defaultProfilePicture),
                foregroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                radius: 15,
              ),
            ),
          ],
          title: Container(
            decoration: BoxDecoration(
              color: kGrey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search Toppick',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: kTextLightColor, fontSize: 14),
              ),
            ),
          ),
          //,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kTextTabBarHeight),
            child: Container(
              // height: 0,
              padding: const EdgeInsets.only(left: 25, bottom: 0),
              width: MediaQuery.of(context).size.width,

              child: TabBar(
                tabs: const [
                  Tab(
                    text: 'For you',
                  ),
                  Tab(
                    text: 'Trending',
                  ),
                  Tab(
                    text: 'Videos',
                  ),
                ],
                splashFactory: NoSplash.splashFactory,
                labelColor: themeProvider.isDarkMode ? kWhite : kBlack,
                unselectedLabelColor: kTextLightColor,
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
          )),
      body: Body(
        tabController: tabController,
      ),
    );
  }
}

// AppBar(
//       scrolledUnderElevation: 3,
//       leading: Padding(
//         padding: const EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
//         child: CircleAvatar(
//           // ignore: prefer_if_null_operators
//           backgroundImage: NetworkImage(url),
//           radius: 15,
//         ),
//       ),
//       title: const Text(''),
//     );

