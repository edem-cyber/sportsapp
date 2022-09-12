import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../environment.dart';
import '../models/Country.dart';
import '../models/League.dart';

class LeaguesProvider with ChangeNotifier {
  final FirebaseFirestore _dataBase = FirebaseFirestore.instance;
  final List<League> _leagues = [];

  List<League> get leagues => [..._leagues];

  Future<List<League>> fetchLeaguesByCountry(
      Country country, int season) async {
    // check if we have the current season
    // if (_season == null) await _fetchCurrentSeason();

    http.Response response = await http.get(
        Uri.parse(
            '${Environment.leaguesUrl}${country.code ?? country.country}/$season'),
        headers: Environment.requestHeaders);
    Map<String, dynamic> res = json.decode(response.body);
    List<League> fetchedLeagues = [];
    for (int i = 0; i < res['api']['leagues'].length; i++) {
      fetchedLeagues.add(League.fromJson(res['api']['leagues'][i]));
    }
    return fetchedLeagues;
  }

  addLeagueToFavorite(League league) {
    _leagues.add(league);
    notifyListeners();
  }

  removeLeagueFromFavorite(League league) {
    _leagues.removeWhere((League l) => l.leagueId == league.leagueId);
    notifyListeners();
  }

  isFavoriteLeague(int leagueId) {
    bool isFavorite = false;
    for (var league in _leagues) {
      if (leagueId == league.leagueId) isFavorite = true;
    }
    return isFavorite;
  }

  isLeagueFromCountry(String countryCode) {
    bool isFavorite = false;
    for (var league in _leagues) {
      if (league.countryCode == countryCode) isFavorite = true;
    }
    return isFavorite;
  }

  League getLeagueById(int leagueId) {
    return _leagues.firstWhere((League league) => league.leagueId == leagueId);
  }

  storeUserPrefs(String? userId) async {
    if (userId != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('user')!;
    }
    if (userId == null) return;
    var reference = _dataBase.collection(userId);
    final QuerySnapshot result = await reference.get();
    final List<DocumentSnapshot> documents = result.docs;
    for (var doc in documents) {
      reference.doc(doc.id).delete();
    }
    for (var league in _leagues) {
      reference.add(league.toJson());
    }
  }

  Future<bool> fetchUserPrefs(String? userId) async {
    if (userId != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('user')!;
    }

    var reference = _dataBase.collection(userId!);
    final QuerySnapshot result = await reference.get();
    final List<DocumentSnapshot> documents = result.docs;
    _leagues.clear();
    // for (var doc in documents) {
    //   _leagues.add(League.fromJson(doc.data() as Map<String, dynamic>));
    // }
    //map the data to the model
    var leagues = documents.map((doc) {
      return League.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
    _leagues.addAll(leagues);
    return true;
  }

  flushLeagues() {
    _leagues.clear();
  }
}