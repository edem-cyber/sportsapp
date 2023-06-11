import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sportsapp/helper/app_images.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/providers/AuthProvider.dart';
import 'package:http/http.dart' as http;
import 'package:sportsapp/screens/single_league_page/single_league_page.dart';

import '../../models/Match.dart';

class LeagueScreen extends StatefulWidget {
  static const String routeName = '/LeagueScreen';
  const LeagueScreen({Key? key}) : super(key: key);

  @override
  State<LeagueScreen> createState() => _LeagueScreenState();
}

class _LeagueScreenState extends State<LeagueScreen>
    with TickerProviderStateMixin {
  late Future<List<League>> leaguesShown;

  Future<List<League>> getallleagues() async {
    //LOAD FROM .ENV FILE
    await dotenv.load(fileName: ".env");
    List<League> leaguesList = [];
    http.Response response = await http.get(
      Uri.parse('http://api.football-data.org/v4/competitions'),
      headers: {
        "X-Auth-Token": dotenv.env['API_TOKEN']!,
      },
    );
    debugPrint("STATUS:  ${response.statusCode}");
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      debugPrint("STATUS:  $data");
      List<dynamic> leagues = data['competitions'];
      leaguesList = leagues.map((e) => League.fromJson(e)).toList();
    } else if (response.statusCode == 400) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> errorMessage = data['message'];
      debugPrint("ERROR 400 IS: $errorMessage");
    } else {}
    debugPrint("LEAGUES ARE: $leaguesList");
    return leaguesList;
  }

  @override
  void initState() {
    super.initState();
    leaguesShown = getallleagues();
  }

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
      body: FutureBuilder<List<League>>(
        future: leaguesShown,
        initialData: const [],
        // initialData: const <String, dynamic>{},
        builder: (context, snapshot) {
          debugPrint("SNAPSHOT IS: $snapshot");
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                var league = snapshot.data![index];
                //check if league code is in leagueCodes list
                if (leagueCodes.contains(league.code)) {
                  return ListTile(
                    minVerticalPadding: 30,
                    leading: CircleAvatar(
                      backgroundColor: kWhite,
                      radius: 50,
                      child: league.emblem!.contains('.svg')
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: SvgPicture.network(
                                  league.emblem!,
                                  fit: BoxFit.cover,
                                  placeholderBuilder: (context) => const Center(
                                    child: Icon(Icons.error),
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
                                  imageUrl: league.emblem!,
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
                    title: Text(
                      league.name!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onTap: () {
                      //push with material page route
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeagueDetailsScreen(
                            code: league.code!,
                          ),
                        ),
                      );
                      // debugPrint("LEAGUE CODE: ${league.code}");
                    },

                    // title: Text(league.name!),
                    // subtitle: Text(league.code!),
                  );
                } else {
                  return const SizedBox();
                }
              },
            );
          }
          if (snapshot.hasError || snapshot.data == null) {
            debugPrint("ERROR IS:  ${snapshot.error}");
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
