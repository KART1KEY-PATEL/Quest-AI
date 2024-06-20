import 'package:flutter/material.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/textUtil.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;
    double sH = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sW * 0.05,
        vertical: sH * 0.08,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: sW * 0.6,
                child: txt(
                  "Welcome to Quest IAS ",
                  textAlign: TextAlign.center,
                  size: sW * 0.1,
                  color: AppColors.secondaryTextColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          Container(
            child: Column(
              children: [
                Image.asset(
                  "assets/images/robot.png",
                  width: sW * 0.4,
                ),
                txt(
                  "Quest IAS AI",
                  size: sW * 0.1,
                  color: AppColors.accentTextColor,
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () => Navigator.pushNamed(context, "/base"),
            child: Container(
              height: sH * 0.07,
              width: sW * 0.8,
              decoration: BoxDecoration(
                color: AppColors.primaryButtonColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: txt(
                  "Start Chat",
                  color: Colors.white,
                  size: sW * 0.05,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
