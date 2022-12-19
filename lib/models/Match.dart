class AutoGenerate {
  AutoGenerate({
    required this.filters,
    required this.resultSet,
    required this.competition,
    required this.matches,
  });
  late final Filters filters;
  late final ResultSet resultSet;
  late final Competition competition;
  late final List<Matches> matches;

  AutoGenerate.fromJson(Map<String, dynamic> json) {
    filters = Filters.fromJson(json['filters']);
    resultSet = ResultSet.fromJson(json['resultSet']);
    competition = Competition.fromJson(json['competition']);
    matches =
        List.from(json['matches']).map((e) => Matches.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['filters'] = filters.toJson();
    _data['resultSet'] = resultSet.toJson();
    _data['competition'] = competition.toJson();
    _data['matches'] = matches.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Filters {
  Filters({
    required this.season,
    required this.matchday,
  });
  late final String season;
  late final String matchday;

  Filters.fromJson(Map<String, dynamic> json) {
    season = json['season'];
    matchday = json['matchday'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['season'] = season;
    _data['matchday'] = matchday;
    return _data;
  }
}

class ResultSet {
  ResultSet({
    required this.count,
    required this.first,
    required this.last,
    required this.played,
  });
  late final int count;
  late final String first;
  late final String last;
  late final int played;

  ResultSet.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    first = json['first'];
    last = json['last'];
    played = json['played'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['count'] = count;
    _data['first'] = first;
    _data['last'] = last;
    _data['played'] = played;
    return _data;
  }
}

class Competition {
  Competition({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    required this.emblem,
  });
  late final int id;
  late final String name;
  late final String code;
  late final String type;
  late final String emblem;

  Competition.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    type = json['type'];
    emblem = json['emblem'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['code'] = code;
    _data['type'] = type;
    _data['emblem'] = emblem;
    return _data;
  }
}

class Matches {
  Matches({
    this.area,
    this.competition,
    this.season,
    this.id,
    this.utcDate,
    this.status,
    this.matchday,
    this.stage,
    this.group,
    this.lastUpdated,
    this.homeTeam,
    this.awayTeam,
    this.score,
    this.odds,
    this.referees,
  });
  Area? area;
  Competition? competition;
  Season? season;
  int? id;
  String? utcDate;
  String? status;
  int? matchday;
  String? stage;
  String? group;
  String? lastUpdated;
  HomeTeam? homeTeam;
  AwayTeam? awayTeam;
  Score? score;
  Odds? odds;
  List<dynamic>? referees;

  Matches.fromJson(Map<String, dynamic> json) {
    area = Area.fromJson(json['area']);
    competition = Competition.fromJson(json['competition']);
    season = Season.fromJson(json['season']);
    id = json['id'];
    utcDate = json['utcDate'];
    status = json['status'];
    matchday = json['matchday'];
    stage = json['stage'];
    group = null;
    lastUpdated = json['lastUpdated'];
    homeTeam = HomeTeam.fromJson(json['homeTeam']);
    awayTeam = AwayTeam.fromJson(json['awayTeam']);
    score = Score.fromJson(json['score']);
    odds = Odds.fromJson(json['odds']);
    referees = List.castFrom<dynamic, dynamic>(json['referees']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['area'] = area!.toJson();
    _data['competition'] = competition!.toJson();
    _data['season'] = season!.toJson();
    _data['id'] = id;
    _data['utcDate'] = utcDate;
    _data['status'] = status;
    _data['matchday'] = matchday;
    _data['stage'] = stage;
    _data['group'] = group;
    _data['lastUpdated'] = lastUpdated;
    _data['homeTeam'] = homeTeam!.toJson();
    _data['awayTeam'] = awayTeam!.toJson();
    _data['score'] = score!.toJson();
    _data['odds'] = odds!.toJson();
    _data['referees'] = referees;
    return _data;
  }
}

class Area {
  Area({
    required this.id,
    required this.name,
    required this.code,
    required this.flag,
  });
  late final int id;
  late final String name;
  late final String code;
  late final String flag;

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['code'] = code;
    _data['flag'] = flag;
    return _data;
  }
}

class Season {
  Season({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.currentMatchday,
    this.winner,
  });
  late final int id;
  late final String startDate;
  late final String endDate;
  late final int currentMatchday;
  late final Null winner;

  Season.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    currentMatchday = json['currentMatchday'];
    winner = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['startDate'] = startDate;
    _data['endDate'] = endDate;
    _data['currentMatchday'] = currentMatchday;
    _data['winner'] = winner;
    return _data;
  }
}

class HomeTeam {
  HomeTeam({
    required this.id,
    required this.name,
    required this.shortName,
    required this.tla,
    required this.crest,
  });
  late final int id;
  late final String name;
  late final String shortName;
  late final String tla;
  late final String crest;

  HomeTeam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['shortName'];
    tla = json['tla'];
    crest = json['crest'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['shortName'] = shortName;
    _data['tla'] = tla;
    _data['crest'] = crest;
    return _data;
  }
}

class AwayTeam {
  AwayTeam({
    required this.id,
    required this.name,
    required this.shortName,
    required this.tla,
    required this.crest,
  });
  late final int id;
  late final String name;
  late final String shortName;
  late final String tla;
  late final String crest;

  AwayTeam.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['shortName'];
    tla = json['tla'];
    crest = json['crest'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['shortName'] = shortName;
    _data['tla'] = tla;
    _data['crest'] = crest;
    return _data;
  }
}

class Score {
  Score({
    this.winner,
    required this.duration,
    required this.fullTime,
    required this.halfTime,
  });
  late final Null winner;
  late final String duration;
  late final FullTime fullTime;
  late final HalfTime halfTime;

  Score.fromJson(Map<String, dynamic> json) {
    winner = null;
    duration = json['duration'];
    fullTime = FullTime.fromJson(json['fullTime']);
    halfTime = HalfTime.fromJson(json['halfTime']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['winner'] = winner;
    _data['duration'] = duration;
    _data['fullTime'] = fullTime.toJson();
    _data['halfTime'] = halfTime.toJson();
    return _data;
  }
}

class FullTime {
  FullTime({
    this.home,
    this.away,
  });
  late final Null home;
  late final Null away;

  FullTime.fromJson(Map<String, dynamic> json) {
    home = null;
    away = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['home'] = home;
    _data['away'] = away;
    return _data;
  }
}

class HalfTime {
  HalfTime({
    this.home,
    this.away,
  });
  late final Null home;
  late final Null away;

  HalfTime.fromJson(Map<String, dynamic> json) {
    home = null;
    away = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['home'] = home;
    _data['away'] = away;
    return _data;
  }
}

class Odds {
  Odds({
    required this.msg,
  });
  late final String msg;

  Odds.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['msg'] = msg;
    return _data;
  }
}
