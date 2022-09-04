class Leagues {
  Leagues({
    required this.get,
    required this.parameters,
    required this.errors,
    required this.results,
    required this.paging,
    required this.response,
  });

  Leagues.fromJson(Map<String, dynamic> json) {
    get = json['get'];
    parameters = Parameters.fromJson(json['parameters']);
    errors = List.castFrom<dynamic, dynamic>(json['errors']);
    results = json['results'];
    paging = Paging.fromJson(json['paging']);
    response =
        List.from(json['response']).map((e) => Response.fromJson(e)).toList();
  }

  late final List<dynamic> errors;
  late final String get;
  late final Paging paging;
  late final Parameters parameters;
  late final List<Response> response;
  late final int results;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['get'] = get;
    _data['parameters'] = parameters.toJson();
    _data['errors'] = errors;
    _data['results'] = results;
    _data['paging'] = paging.toJson();
    _data['response'] = response.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Parameters {
  Parameters({
    required this.id,
  });

  Parameters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  late final String id;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    return _data;
  }
}

class Paging {
  Paging({
    required this.current,
    required this.total,
  });

  Paging.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    total = json['total'];
  }

  late final int current;
  late final int total;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['current'] = current;
    _data['total'] = total;
    return _data;
  }
}

class Response {
  Response({
    required this.league,
    required this.country,
    required this.seasons,
  });

  Response.fromJson(Map<String, dynamic> json) {
    league = League.fromJson(json['league']);
    country = Country.fromJson(json['country']);
    seasons =
        List.from(json['seasons']).map((e) => Seasons.fromJson(e)).toList();
  }

  late final Country country;
  late final League league;
  late final List<Seasons> seasons;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['league'] = league.toJson();
    _data['country'] = country.toJson();
    _data['seasons'] = seasons.map((e) => e.toJson()).toList();
    return _data;
  }
}

class League {
  League({
    required this.id,
    required this.name,
    required this.type,
    required this.logo,
  });

  League.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    logo = json['logo'];
  }

  late final int id;
  late final String logo;
  late final String name;
  late final String type;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['type'] = type;
    _data['logo'] = logo;
    return _data;
  }
}

class Country {
  Country({
    required this.name,
    required this.code,
    required this.flag,
  });

  Country.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    flag = json['flag'];
  }

  late final String code;
  late final String flag;
  late final String name;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['code'] = code;
    _data['flag'] = flag;
    return _data;
  }
}

class Seasons {
  Seasons({
    required this.year,
    required this.start,
    required this.end,
    required this.current,
    required this.coverage,
  });

  Seasons.fromJson(Map<String, dynamic> json) {
    year = json['year'];
    start = json['start'];
    end = json['end'];
    current = json['current'];
    coverage = Coverage.fromJson(json['coverage']);
  }

  late final Coverage coverage;
  late final bool current;
  late final String end;
  late final String start;
  late final int year;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['year'] = year;
    _data['start'] = start;
    _data['end'] = end;
    _data['current'] = current;
    _data['coverage'] = coverage.toJson();
    return _data;
  }
}

class Coverage {
  Coverage({
    required this.fixtures,
    required this.standings,
    required this.players,
    required this.topScorers,
    required this.topAssists,
    required this.topCards,
    required this.injuries,
    required this.predictions,
    required this.odds,
  });

  Coverage.fromJson(Map<String, dynamic> json) {
    fixtures = Fixtures.fromJson(json['fixtures']);
    standings = json['standings'];
    players = json['players'];
    topScorers = json['top_scorers'];
    topAssists = json['top_assists'];
    topCards = json['top_cards'];
    injuries = json['injuries'];
    predictions = json['predictions'];
    odds = json['odds'];
  }

  late final Fixtures fixtures;
  late final bool injuries;
  late final bool odds;
  late final bool players;
  late final bool predictions;
  late final bool standings;
  late final bool topAssists;
  late final bool topCards;
  late final bool topScorers;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fixtures'] = fixtures.toJson();
    _data['standings'] = standings;
    _data['players'] = players;
    _data['top_scorers'] = topScorers;
    _data['top_assists'] = topAssists;
    _data['top_cards'] = topCards;
    _data['injuries'] = injuries;
    _data['predictions'] = predictions;
    _data['odds'] = odds;
    return _data;
  }
}

class Fixtures {
  Fixtures({
    required this.events,
    required this.lineups,
    required this.statisticsFixtures,
    required this.statisticsPlayers,
  });

  Fixtures.fromJson(Map<String, dynamic> json) {
    events = json['events'];
    lineups = json['lineups'];
    statisticsFixtures = json['statistics_fixtures'];
    statisticsPlayers = json['statistics_players'];
  }

  late final bool events;
  late final bool lineups;
  late final bool statisticsFixtures;
  late final bool statisticsPlayers;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['events'] = events;
    _data['lineups'] = lineups;
    _data['statistics_fixtures'] = statisticsFixtures;
    _data['statistics_players'] = statisticsPlayers;
    return _data;
  }
}
