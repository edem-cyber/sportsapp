import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sportsapp/helper/constants.dart';
import 'package:sportsapp/models/Match.dart';
import 'package:sportsapp/providers/LeaguesProvider.dart';
import 'package:sportsapp/providers/ThemeProvider.dart';
//import http package
import 'package:http/http.dart' as http;
import 'dart:convert';

class FixturesTab extends StatefulWidget {
  final String code;
  const FixturesTab({Key? key, required this.code}) : super(key: key);

  @override
  State<FixturesTab> createState() => _FixturesTabState();
}

class _FixturesTabState extends State<FixturesTab> {
  @override
  void initState() {
    super.initState();
    print("CODE: ${widget.code}");
    getMatches(widget.code);
  }

  // var token = "9b317099a8914002994c7d2ffbd43c7f";
  var token = "be1eb21948af4c8fa080ee214406c4be";
  Future<Map<String, dynamic>> getMatches(String code) async {
    List<Matches> extractedMatches = [];
    Response response = await http.get(
      Uri.parse(
          'https://api.football-data.org/v2/competitions/$code/matches?status=SCHEDULED'),
      headers: {"X-Auth-Token": token},
    );
    Map<String, dynamic> data = json.decode(response.body);

    // List<dynamic> matches = data['matches'];
    // print("X: $x");

    //convert dynamic list to list of matches objects and add to extractedMatches
    // extractedMatches = matches.map((e) => Matches.fromJson(e)).toList();

    //arrange matches by matchday in ascending order
    // extractedMatches.sort((a, b) => a.matchday!.compareTo(b.matchday!));

    // print("EXTRACTED MATCHES: ${extractedMatches[0].homeTeam!.name}");
    // print("EXTRACTED MATCHES: ${extractedMatches[0].homeTeam}");
    print("DATA: ${data["matches"]}");
    //print tla of home team
    print("DATA IMG: ${data["matches"][0]["homeTeam"].name}");

    // print(x.keys);
    // for (var i in y) {
    //   extractedMatches.add(
    //     Matches(
    //       awayTeam: i['awayTeam']['name'],
    //       homeTeam: i['homeTeam']['name'],
    //       matchday: i['matchday'],
    //       utcDate: i['utcDate'],

    //     ),
    //   );
    // }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    var leaguesProvider = Provider.of<LeaguesProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: FutureBuilder<Map<String, dynamic>>(
          future: getMatches(widget.code),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!['matches'].length,
                itemBuilder: (context, index) {
                  var match = snapshot.data!['matches'][index];
                  return SingleMatch(
                    homeTeam: match['homeTeam']['tla'].toString(),
                    awayTeam: match['awayTeam']['tla'].toString(),
                    matchday: match['matchday'],
                    utcDate: match['utcDate'].toString(),
                    homeLogo: leaguesProvider.removeOuterStyleTags(
                        match['homeTeam']['crest'].toString()),
                    awayLogo: leaguesProvider.removeOuterStyleTags(
                        match['awayTeam']['crest'].toString()),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class SingleMatch extends StatelessWidget {
  final String? homeTeam;
  final String? awayTeam;
  final int? matchday;
  final String? utcDate;
  final String? homeLogo;
  final String? awayLogo;
  const SingleMatch({
    Key? key,
    this.homeTeam,
    this.awayTeam,
    this.matchday,
    this.utcDate,
    this.homeLogo,
    this.awayLogo,
  }) : super(key: key);

  String parseMyDate(String date) {
    //parse date from 2022-12-21T19:45:00Z to 19:45
    var mydate = DateTime.parse(date);

    var formattedDate = DateFormat('HH:mm').format(mydate);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          homeTeam!.length > 10
              ? "${homeTeam.toString().substring(0, 10)}..."
              : homeTeam.toString(),
          style: themeProvider.isDarkMode
              ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kWhite,
                  )
              : Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kBlack,
                  ),
        ),
        const SizedBox(
          width: 10,
        ),
        homeLogo.toString().contains('.svg') == true
            ? SvgPicture.network(
                homeLogo ?? "",
                width: 30,
              )
            : CachedNetworkImage(
                imageUrl: homeLogo ?? "",
                width: 30,
              ),
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 60,
          child: Text(
            // regex to remove time from date
            //
            parseMyDate(utcDate ?? ""),
            style: themeProvider.isDarkMode
                ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: kWhite,
                    )
                : Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: kBlack,
                    ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        awayLogo.toString().contains('.svg') == true
            ? SvgPicture.network(
                awayLogo ?? "",
                width: 30,
              )
            : CachedNetworkImage(
                imageUrl: awayLogo ?? "",
                width: 30,
              ),
        const SizedBox(
          width: 10,
        ),
        Text(
          awayTeam!.length > 10
              ? "${awayTeam.toString().substring(0, 6)}..."
              : awayTeam.toString(),
          style: themeProvider.isDarkMode
              ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kWhite,
                  )
              : Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: kBlack,
                  ),
        ),
      ],
    );
  }
}
