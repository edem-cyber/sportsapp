import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
import 'package:sportsapp/screens/single_league_page/widgets/table_screen.dart';
import 'package:sportsapp/screens/leagues/components/demo_leagues.dart';
import 'package:sportsapp/screens/leagues/components/league_item.dart';

class LeagueScreen extends StatefulWidget {
  static const String routeName = '/LeagueScreen';
  const LeagueScreen({Key? key}) : super(key: key);

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
          child: GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: CircleAvatar(
              // ignore: prefer_if_null_operators
              backgroundImage: CachedNetworkImageProvider(
                authProvider.user!.photoURL ?? AppImage.defaultProfilePicture,
                errorListener: () {
                  Shimmer.fromColors(
                    baseColor: const Color(0xFF8F8F8F),
                    highlightColor: Colors.white,
                    child: Container(
                      width: 40,
                      height: 40,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              radius: 15,
            ),
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
              hintText: 'Search Rooms',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kTextLightColor, fontSize: 14),
            ),
          ),
        ),
        //,
      ),
      body: ListView.builder(
        itemCount: demoLeagues.length,
        itemBuilder: (BuildContext context, int index) {
          return LeagueItem(
            text: demoLeagues[index]["leagueName"] ?? "Error Loading",
            image: demoLeagues[index]["logo"] ?? "",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TableScreen(
                    code: demoLeagues[index]['leagueCode']!,
                  ),
                ),
              );
            },
          );
        },
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