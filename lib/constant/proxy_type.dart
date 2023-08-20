//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/8/19
//
enum ProxyType {
  local("本地节点", 0),
  subscription("订阅节点", 1);

  final String title;

  final int value;

  const ProxyType(this.title, this.value);

  static ProxyType getByValue(int value) {
    for (final v in ProxyType.values) {
      if (v.value == value) {
        return v;
      }
    }
    return ProxyType.local;
  }
}