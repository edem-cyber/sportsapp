class League {
  String? leagueId;
  String? name;
  String? type;
  String? country;
  String? countryCode;
  String? season;
  String? seasonStart;
  String? seasonEnd;
  String? logo;
  String? flag;
  String? standings;
  String? isCurrent;

  League(
      {this.leagueId,
      this.name,
      this.type,
      this.country,
      this.countryCode,
      this.season,
      this.seasonStart,
      this.seasonEnd,
      this.logo,
      this.flag,
      this.standings,
      this.isCurrent});

  League.fromJson(Map<String, dynamic> json) {
    leagueId = json['league_id'] as String;
    name = json['name'] as String;
    type = json['type'] as String;
    country = json['country'] as String;
    countryCode = json['country_code'] as String;
    season = json['season'] as String;
    seasonStart = json['season_start'] as String;
    seasonEnd = json['season_end'] as String;
    logo = json['logo'] as String;
    flag = json['flag'] as String;
    standings = json['standings'] as String;
    isCurrent = json['is_current'] as String;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['league_id'] = leagueId;
    data['name'] = name;
    data['type'] = type;
    data['country'] = country;
    data['country_code'] = countryCode;
    data['season'] = season;
    data['season_start'] = seasonStart;
    data['season_end'] = seasonEnd;
    data['logo'] = logo;
    data['flag'] = flag;
    data['standings'] = standings;
    data['is_current'] = isCurrent;
    return data;
  }
}
