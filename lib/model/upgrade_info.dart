//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/24
//
class UpgradeInfo {
  final String version;

  final String url;

  final String? releaseNotes;

  final String? releaseDate;

  final String? sha512;

  UpgradeInfo({
    required this.version,
    required this.url,
    this.releaseNotes,
    this.releaseDate,
    this.sha512,
  });

  factory UpgradeInfo.fromJson(dynamic json) {
    return UpgradeInfo(
      version: json['version'],
      url: json['url'],
      releaseNotes: json['releaseNotes'],
      releaseDate: json['releaseDate'],
      sha512: json['sha512'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['version'] = version;
    map['url'] = url;
    map['releaseNotes'] = releaseNotes;
    map['releaseDate'] = releaseDate;
    map['sha512'] = sha512;
    return map;
  }
}
