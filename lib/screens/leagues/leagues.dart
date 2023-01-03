import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/League.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:sportsapp/providers/LeaguesProvider.dart';
import 'package:http/http.dart' as http;
import 'package:sportsapp/screens/single_league_page/single_league_page.dart';

class LeagueScreen extends StatefulWidget {
  static const String routeName = '/LeagueScreen';
  const LeagueScreen({Key? key}) : super(key: key);

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen>
    with TickerProviderStateMixin {
  late Future<List<League>> leaguesShown;

  var token = "9b317099a8914002994c7d2ffbd43c7f";
  // var token = "be1eb21948af4c8fa080ee214406c4be";

  Future<List<League>> getallleagues() async {
    List<League> leaguesList = [];
    http.Response response = await http.get(
      Uri.parse('http://api.football-data.org/v4/competitions'),
      headers: {
        "X-Auth-Token": token,
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> leagues = data['competitions'];
      //convert dynamic list to list of league objects
      leaguesList = leagues.map((e) => League.fromJson(e)).toList();
      // print("LEAGUE LIST: $leaguesList");
      // return data;
      print("STATUS: ${response.statusCode}");
    } else {}
    return leaguesList;
  }

  @override
  void initState() {
    super.initState();
    leaguesShown = getallleagues();
  }

  @override
  Widget build(BuildContext context) {
    var leaguesProvider = Provider.of<LeaguesProvider>(context);
    //leagues list from provider api
    // var leagues = leaguesProvider.fetchLeaguesList();
    //convert to list of league items
    // var leaguesList = leagues.map((e) => LeagueItem(e)).toList();
    var authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, right: 0, top: 0, bottom: 0),
          child: GestureDetector(
            onTap: () {
              // setState(() {
              Scaffold.of(context).openDrawer();
              // });
            },
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
              hintText: 'Search Leagues',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: kTextLightColor, fontSize: 14),
            ),
          ),
        ),
        //,
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       getallleagues();
      //     },
      //     child: const Text('Get all leagues'),
      //   ),
      // ),
      body: FutureBuilder<List<League>>(
        future: leaguesShown,
        // initialData: const <String, dynamic>{},
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                //check if league code is in leagueCodes list
                //if it is, then show it
                //if not, then don't show it
                if (leagueCodes.contains(snapshot.data![index].code)) {
                  return ListTile(
                    minVerticalPadding: 30,
                    title: Text(
                      snapshot.data![index].name!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () {
                      //push with material page route
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeagueDetailsScreen(
                            code: snapshot.data![index].code!,
                          ),
                        ),
                      );
                      // print("LEAGUE CODE: ${snapshot.data![index].code}");
                    },
                    // leading: CircleAvatar(
                    //   radius: 20,
                    //   backgroundColor: kWhite,
                    //   backgroundImage: CachedNetworkImageProvider(
                    //     snapshot.data![index].emblem!,
                    //     errorListener: () {
                    //       Shimmer.fromColors(
                    //         baseColor: const Color(0xFF8F8F8F),
                    //         highlightColor: Colors.white,
                    //         child: Container(
                    //           width: 40,
                    //           height: 40,
                    //           color: Colors.white,
                    //         ),
                    //       );
                    //     },
                    //   ),
                    // ),
                    leading: CircleAvatar(
                      backgroundColor: kWhite,
                      radius: 50,
                      child: snapshot.data![index].emblem!.contains('.svg')
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: SvgPicture.network(
                                  snapshot.data![index].emblem!,
                                  fit: BoxFit.cover,
                                  placeholderBuilder: (context) => const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data![index].emblem!,
                                  // fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(
                                    child: Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    // title: Text(snapshot.data![index].name!),
                    // subtitle: Text(snapshot.data![index].code!),
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(),
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