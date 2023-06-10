import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportsapp/models/Match.dart';


class LeaguesProvider with ChangeNotifier {
  // final FirebaseFirestore _dataBase = FirebaseFirestore.instance;
  final List<League> _leagues = [];
  // final List<League> _leaguesByCountry = [];

  // // var token = "9b317099a8914002994c7d2ffbd43c7f";
  // var token = "be1eb21948af4c8fa080ee214406c4be";

  List<League> get leagues => [..._leagues];

  String removeOuterStyleTags(String html) {
    RegExp exp = RegExp(r"<style[^>]*>[\s\S]*?</style>");

    html = html.replaceAll(exp, '');

    return html;
  }

  //fetch league standings from football-data api
  Future<List<League>> fetchLeagueStandings(String code, int season) async {
    http.Response response = await http.get(
      // http://api.football-data.org/v4/competitions/PL/standings
      Uri.parse('http://api.football-data.org/v4/competitions/$code/standings'),
    );
    Map<String, dynamic> res = json.decode(response.body);

    return res['standings'][0]['table'];
  }

  addLeagueToFavorite(League league) {
    _leagues.add(league);
    notifyListeners();
  }

  flushLeagues() {
    _leagues.clear();
  }
}
