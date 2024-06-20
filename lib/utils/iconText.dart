
import 'package:flutter/material.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/textUtil.dart';

class IconText extends StatelessWidget {
  const IconText({
    super.key,
    required this.sW,
    required this.sH,
    required this.title,
    required this.icon,
  });

  final double sW;
  final double sH;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryAccentTextColor,
        ),
        SizedBox(
          width: sW * 0.02,
        ),
        txt(
          title,
          size: sH * 0.02,
          weight: FontWeight.w500,
          color: AppColors.primaryAccentTextColor,
        ),
      ],
    );
  }
}
