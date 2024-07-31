import 'package:flutter/material.dart';

class SpacingWidget extends StatelessWidget {
  SpacingWidget({super.key, required this.height});
  double height;
  @override
  Widget build(BuildContext context) {
    double sH = MediaQuery.sizeOf(context).height;
    return SizedBox(
      height: sH * height,
    );
  }
}
