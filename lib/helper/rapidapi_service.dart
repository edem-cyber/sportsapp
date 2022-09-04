import 'dart:convert';
//import http package
import 'package:http/http.dart' as http;
import 'package:sportsapp/models/league.dart';

class APIService {
  static const _authority = "sameer-kumar-aztro-v1.p.rapidapi.com";
  static const _path = "/";
  static const _query = {"sign": "aquarius", "day": "today"};
  static const Map<String, String> _headers = {
    "x-rapidapi-key": "*****************",
    "x-rapidapi-host": "sameer-kumar-aztro-v1.p.rapidapi.com",
  };

  // Base API request to get response
  Future<League> get() async {
    Uri uri = Uri.https(_authority, _path, _query);
    final response = await http.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      final jsonMap = json.decode(response.body);
      return League.fromJson(jsonMap);
    } else {
      // If that response was not OK, throw an error.
      throw Exception(
          'API call returned: ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}
