//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/23
//
import 'dart:async';

import 'package:flutter/foundation.dart';


class Utils {
  Utils._();

  /// 防抖
  static VoidCallback debounce(
    VoidCallback callback, [
    Duration duration = const Duration(seconds: 1),
  ]) {
    assert(duration > Duration.zero);
    Timer? debounce;
    return () {
      // 还在时间之内，抛弃上一次
      // 执行最后一次
      if (debounce?.isActive ?? false) {
        debounce?.cancel();
      }
      debounce = Timer(duration, () {
        callback.call();
      });
    };
  }

  /// 节流
  static VoidCallback throttle(
    VoidCallback callback, [
    Duration duration = const Duration(seconds: 1),
  ]) {
    assert(duration > Duration.zero);
    Timer? throttle;
    return () {
      // 执行第一次
      if (throttle?.isActive ?? false) {
        return;
      }
      callback.call();
      throttle = Timer(duration, () {});
    };
  }
}
