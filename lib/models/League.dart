class League {
  int? id;
  Area? area;
  String? name;
  String? code;
  String? type;
  String? emblem;
  String? plan;
  CurrentSeason? currentSeason;
  int? numberOfAvailableSeasons;
  String? lastUpdated;

  League({
    this.id,
    this.area,
    this.name,
    this.code,
    this.type,
    this.emblem,
    this.plan,
    this.currentSeason,
    this.numberOfAvailableSeasons,
    this.lastUpdated,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      area: Area.fromJson(json['area']),
      name: json['name'],
      code: json['code'],
      type: json['type'],
      emblem: json['emblem'],
      plan: json['plan'],
      currentSeason: CurrentSeason.fromJson(json['currentSeason']),
      numberOfAvailableSeasons: json['numberOfAvailableSeasons'],
      lastUpdated: json['lastUpdated'],
    );
  }
}

class Area {
  int? id;
  String? name;
  String? code;
  String? flag;

  Area({
    this.id,
    this.name,
    this.code,
    this.flag,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      flag: json['flag'],
    );
  }
}

class CurrentSeason {
  int? id;
  DateTime? startDate;
  DateTime? endDate;
  int? currentMatchday;
  dynamic winner;

  CurrentSeason({
    this.id,
    this.startDate,
    this.endDate,
    this.currentMatchday,
    this.winner,
  });

  factory CurrentSeason.fromJson(Map<String, dynamic> json) {
    return CurrentSeason(
      id: json['id'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      currentMatchday: json['currentMatchday'],
      winner: json['winner'],
    );
  }
}
