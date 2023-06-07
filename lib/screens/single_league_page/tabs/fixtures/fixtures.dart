import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Fixture.dart';
//import http package
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sportsapp/screens/single_league_page/tabs/fixtures/widgets/single_match.dart';

class FixturesTab extends StatefulWidget {
  final String? code;
  final ScrollController scrollController;
  const FixturesTab(
      {Key? key, required this.code, required this.scrollController})
      : super(key: key);

  @override
  State<FixturesTab> createState() => _FixturesTabState();
}

class _FixturesTabState extends State<FixturesTab>
    with AutomaticKeepAliveClientMixin {
  //var to store the matches
  late Future<List<Fixture>> stateFixtures;
  // var token = "9b317099a8914002994c7d2ffbd43c7f";
  // // var token = "be1eb21948af4c8fa080ee214406c4be";
  // Future<Map<String, dynamic>> getMatches(String code) async {
  //   List<Matches> extractedMatches = [];
  //   Response response = await http.get(
  //     Uri.parse(
  //         'https://api.football-data.org/v2/competitions/$code/matches?matchday='),
  //     headers: {"X-Auth-Token": token},
  //   );
  //   Map<String, dynamic> data = json.decode(response.body);

  //   // List<dynamic> matches = data['matches'];
  //   // print("X: $x");

  //   //convert dynamic list to list of matches objects and add to extractedMatches
  //   // extractedMatches = matches.map((e) => Matches.fromJson(e)).toList();

  //   //arrange matches by matchday in ascending order
  //   // extractedMatches.sort((a, b) => a.matchday!.compareTo(b.matchday!));

  //   // print("EXTRACTED MATCHES: ${extractedMatches[0].homeTeam!.name}");
  //   // print("EXTRACTED MATCHES: ${extractedMatches[0].homeTeam}");
  //   print("DATA: ${data["matches"]}");
  //   //print tla of home team
  //   print("DATA IMG: ${data["matches"][0]}");

  //   // print(x.keys);
  //   // for (var i in y) {
  //   //   extractedMatches.add(
  //   //     Matches(
  //   //       awayTeam: i['awayTeam']['name'],
  //   //       homeTeam: i['homeTeam']['name'],
  //   //       matchday: i['matchday'],
  //   //       utcDate: i['utcDate'],

  //   //     ),
  //   //   );
  //   // }
  //   return data;
  // }

  Future<List<Fixture>> getFixtures(String leagueCode) async {
    final response = await http.get(
        Uri.parse(
            'http://api.football-data.org/v4/competitions/$leagueCode/matches'),
        headers: {"X-Auth-Token": token});
    if (response.statusCode == 200) {
      // parse the response and create a list of fixtures
      List<Fixture> fixtures = [];
      final data = jsonDecode(response.body)['matches'];
      print("DATA: $data");
      for (var fixture in data) {
        fixtures.add(Fixture(
          homeTeamLogo: fixture['homeTeam']['crest'],
          awayTeamLogo: fixture['awayTeam']['crest'],
          homeTeamTla: fixture['homeTeam']['tla'],
          awayTeamTla: fixture['awayTeam']['tla'],
          time: DateTime.parse(fixture['utcDate']),
          matchday: fixture['matchday'],
        ));
      }

      return fixtures;
    } else {
      print("ERROR: ${response.statusCode}");
      throw Exception('Failed to load fixtures');
    }
  }

  @override
  void initState() {
    super.initState();
    getFixtures(widget.code!);

    setState(() {
      stateFixtures = getFixtures(widget.code!);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Fixture>>(
      future: getFixtures(widget.code!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // sort the fixtures by match day
          List<Fixture> fixtures = snapshot.data!;
          return Scrollbar(
            controller: widget.scrollController,
            thumbVisibility: true,
            interactive: true,
            child: ListView.builder(
              controller: widget.scrollController,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: fixtures.length,
              itemBuilder: (context, index) {
                Fixture fixture = fixtures[index];
                //DISPLAY ACCORDING TO MATCHDAY
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 0 ||
                          fixtures[index - 1].matchday != fixture.matchday)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text("Matchday ${fixture.matchday}",
                              style: Theme.of(context).textTheme.titleLarge!),
                        ),
                      // else if (fixture.matchday == null)
                      SingleMatch(
                        homeTeam: fixture.homeTeamTla,
                        awayTeam: fixture.awayTeamTla,
                        matchday: fixture.matchday,
                        utcDate: fixture.time.toString(),
                        homeLogo: fixture.homeTeamLogo,
                        awayLogo: fixture.awayTeamLogo,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: CupertinoActivityIndicator());
        }
        return const Center(child: CupertinoActivityIndicator());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
