//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/15
//
class FilterApp {
  final String packageName;

  FilterApp({
    this.packageName = "",
  });

  FilterApp copyWith({
    String? packageName,
  }) {
    return FilterApp(
      packageName: packageName ?? this.packageName,
    );
  }

  factory FilterApp.fromJson(dynamic json) {
    return FilterApp(
      packageName: json['packageName'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['packageName'] = packageName;
    return map;
  }
}
