import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:sportsapp/helper/constants.dart';
// import 'package:sportsapp/helper/constants.dart';

class LeagueTable extends StatefulWidget {
  final String code;

  const LeagueTable({Key? key, required this.code}) : super(key: key);
  @override
  State<LeagueTable> createState() => _LeagueTableState();
}

class _LeagueTableState extends State<LeagueTable>
    with AutomaticKeepAliveClientMixin {
  var _table = [];
  // // var token = "9b317099a8914002994c7d2ffbd43c7f";
  // var token = "be1eb21948af4c8fa080ee214406c4be";

  getTable() async {
    await dotenv.load(fileName: ".env");

    http.Response response = await http.get(
        Uri.parse(
            'http://api.football-data.org/v2/competitions/${widget.code}/standings'),
        headers: {
          'X-Auth-Token': dotenv.env['API_TOKEN']!,
        });
    String body = response.body;
    Map data = jsonDecode(body);
    List table = data['standings'][0]['table'];
    setState(() {
      _table = table;
    });
  }

  @override
  void initState() {
    super.initState();
    getTable();
  }

  Widget buildTable() {
    List<Widget> teams = [];
    for (var team in _table) {
      teams.add(
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    team['position'].toString().length > 1
                        ? Text('${team['position']} ')
                        : Text(" " + team['position'].toString() + '  '),
                    Row(
                      children: [
                        team['team']['crestUrl'].toString().contains(".svg")
                            ? CircleAvatar(
                                radius: 20,
                                backgroundColor: kGrey,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: kWhite,
                                  child: SvgPicture.network(
                                    team['team']['crestUrl'],
                                    fit: BoxFit.cover,
                                    width: 27,
                                    // width: 20,
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: kGrey,
                                radius: 20,
                                child: CircleAvatar(
                                  radius: 18,
                                  backgroundColor: kWhite,
                                  child: Image.network(
                                    fit: BoxFit.cover,
                                    team['team']['crestUrl'].toString(),
                                    width: 27,
                                  ),
                                ),
                              ),
                        const SizedBox(
                          width: 10,
                        ),
                        team['team']['name'].toString().length > 11
                            ? Text(
                                '${team['team']['name'].toString().substring(0, 10)}...')
                            : Text(team['team']['name'].toString()),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(team['playedGames'].toString()),
                    Text(team['won'].toString()),
                    Text(team['draw'].toString()),
                    Text(team['lost'].toString()),
                    Text(team['goalDifference'].toString()),
                    Text(team['points'].toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Column(
      children: teams,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _table == []
        ? Container(
            color: Colors.white,
            child: const Center(child: CupertinoActivityIndicator()),
          )
        : Container(
            decoration: const BoxDecoration(
                // color: kWhite,
                // gradient: LinearGradient(
                //   colors: [
                //     kWhite,
                //     kWhite,
                //   ],
                //   begin: FractionalOffset(0.0, 0.0),
                //   end: FractionalOffset(0.0, 1.0),
                //   stops: [0.0, 1.0],
                //   tileMode: TileMode.clamp,
                // ),
                ),
            child: ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              'Pos',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              'Teams',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // 'PL',
                              'MP',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'W',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'D',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'L',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'GD',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Pts',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                buildTable(),
              ],
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
