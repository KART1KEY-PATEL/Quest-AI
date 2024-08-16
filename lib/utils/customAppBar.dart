// Custom AppBar Component
import 'package:flutter/material.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/textUtil.dart';

PreferredSizeWidget customAppBar({
  required String title,
  List<Widget>? actions,
  Widget? leading,
  Color backgroundColor = AppColors.primaryColor,
  Color titleColor = AppColors.primaryTextColor,
  double elevation = 0.0,
  bool centerTitle = false,
  double textSize = 24,
}) {
  return AppBar(
    title: txt(
      title,
      isBold: true,
      size: textSize,
      color: titleColor,
    ),
    automaticallyImplyLeading: leading != null ? true : false,
    backgroundColor: backgroundColor,
    elevation: elevation,
    centerTitle: centerTitle,
    actions: actions,
    leading: leading,
  );
}
