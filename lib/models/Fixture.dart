class Fixture {
  final String? homeTeamLogo;
  final String? homeTeamTla;
  final String? awayTeamLogo;
  final String? awayTeamTla;
  final DateTime? time;
  final int? matchday;

  Fixture({
    this.homeTeamLogo,
    this.homeTeamTla,
    this.awayTeamLogo,
    this.awayTeamTla,
    this.time,
    this.matchday,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      homeTeamLogo: json['homeTeam']['crest'],
      homeTeamTla: json['homeTeam']['tla'],
      awayTeamLogo: json['awayTeam']['crest'],
      awayTeamTla: json['awayTeam']['tla'],
      time: DateTime.parse(json['utcDate']),
      matchday: json['matchday'],
    );
  }
}
