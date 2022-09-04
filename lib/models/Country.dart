class Country {
  String? country;
  String? code;
  String? flag;

  Country({this.country, this.code, this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    code = json['code'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['code'] = code;
    data['flag'] = flag;
    return data;
  }
}
