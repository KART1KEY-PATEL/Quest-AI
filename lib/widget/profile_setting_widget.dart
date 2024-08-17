import 'package:flutter/material.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/textUtil.dart';

class ProfileSettingWidget extends StatelessWidget {
  const ProfileSettingWidget({
    super.key,
    required this.sH,
    required this.title,
    required this.routeToRedirect,
  });

  final double sH;
  final String title;
  final String routeToRedirect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, routeToRedirect);
      },
      child: Container(
        height: sH * 0.07,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            txt(title, size: sH * 0.015, weight: FontWeight.bold),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.blackSVG,
            )
          ],
        ),
      ),
    );
  }
}
