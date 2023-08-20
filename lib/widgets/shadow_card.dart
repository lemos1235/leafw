//
// [Author] lg (https://github.com/lemos1235)
// [Date] 2023/3/30
//
import 'package:flutter/material.dart';

class ShadowCard extends StatelessWidget {
  ///背景色 默认Color(0xfffafafa)
  final Color? color;

  ///阴影颜色 默认Color(0xffeeeeee)
  final Color? shadowColor;

  ///阴影偏移量 默认是0
  final Offset offset;

  ///内边距 默认是0
  final EdgeInsetsGeometry padding;

  ///圆角
  final BorderRadiusGeometry? borderRadius;

  ///子 Widget
  final Widget child;

  ///阴影模糊程度 默认5.0
  final double blurRadius;

  ///阴影扩散程度 默认0
  final double spreadRadius;

  ///边框的宽度 默认0.5
  final double borderWidth;

  final EdgeInsetsGeometry? margin;

  final bool noShadow;

  ShadowCard(
      {required this.child,
      this.color,
      this.shadowColor,
      this.padding = const EdgeInsets.all(0),
      this.borderRadius = const BorderRadius.all(Radius.circular(5)),
      this.blurRadius = 5.0,
      this.spreadRadius = 0,
      this.offset = Offset.zero,
      this.borderWidth = 0.5,
      this.noShadow = false,
      this.margin});

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    double tempBorderWidth = 0;
    if (borderWidth > 0) {
      tempBorderWidth = borderWidth;
    }
    Color defaultBorderColor = isDark ? Color(0xFF303030) : Color(0xFFF0F0F0);
    Color defaultShadowColor = isDark ? Color.fromRGBO(0, 0, 0, 0.72) : Color(0xFFEEEEEE);
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: tempBorderWidth != 0
            ? Border.all(color: defaultBorderColor, width: tempBorderWidth)
            : Border.all(style: BorderStyle.none),
        boxShadow: [
          if (!noShadow)
            BoxShadow(
              color: cardTheme.shadowColor ?? shadowColor ?? defaultShadowColor,
              offset: offset, //阴影xy轴偏移量
              blurRadius: blurRadius, //阴影模糊程度
              spreadRadius: spreadRadius, //阴影扩散程度
            )
        ],
      ),
      child: Material(
        borderRadius: borderRadius,
        color: color ?? cardTheme.color,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
