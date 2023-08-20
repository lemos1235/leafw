//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/15
//
enum FilterMode {
  off("不启用", 0),
  allow("代理", 1),
  disallow("绕行", 2);

  final String title;

  final int value;

  const FilterMode(this.title, this.value);

  static FilterMode getByValue(int value) {
    for (final v in FilterMode.values) {
      if (v.value == value) {
        return v;
      }
    }
    return FilterMode.off;
  }
}
