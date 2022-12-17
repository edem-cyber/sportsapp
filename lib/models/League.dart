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

  League(
      {this.id,
      this.area,
      this.name,
      this.code,
      this.type,
      this.emblem,
      this.plan,
      this.currentSeason,
      this.numberOfAvailableSeasons,
      this.lastUpdated});

  League.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    name = json['name'];
    code = json['code'];
    type = json['type'];
    emblem = json['emblem'];
    plan = json['plan'];
    currentSeason = json['currentSeason'] != null
        ? CurrentSeason.fromJson(json['currentSeason'])
        : null;
    numberOfAvailableSeasons = json['numberOfAvailableSeasons'];
    lastUpdated = json['lastUpdated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (area != null) {
      data['area'] = area!.toJson();
    }
    data['name'] = name;
    data['code'] = code;
    data['type'] = type;
    data['emblem'] = emblem;
    data['plan'] = plan;
    if (currentSeason != null) {
      data['currentSeason'] = currentSeason!.toJson();
    }
    data['numberOfAvailableSeasons'] = numberOfAvailableSeasons;
    data['lastUpdated'] = lastUpdated;
    return data;
  }
}

class Area {
  int? id;
  String? name;
  String? code;
  String? flag;

  Area({this.id, this.name, this.code, this.flag});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['flag'] = flag;
    return data;
  }
}

class CurrentSeason {
  int? id;
  String? startDate;
  String? endDate;
  int? currentMatchday;
  String? winner;

  CurrentSeason(
      {this.id,
      this.startDate,
      this.endDate,
      this.currentMatchday,
      this.winner});

  CurrentSeason.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    currentMatchday = json['currentMatchday'];
    winner = json['winner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['currentMatchday'] = currentMatchday;
    data['winner'] = winner;
    return data;
  }
}
