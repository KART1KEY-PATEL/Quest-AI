import 'package:flutter/material.dart';
import 'package:questias/utils/color.dart';
import 'package:questias/utils/textUtil.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validate,
    required this.maxLines,
    this.obsureText = false,
  });
  String hintText;
  TextEditingController controller;
  bool validate;
  int maxLines;
  bool obsureText;
  @override
  Widget build(BuildContext context) {
    double sH = MediaQuery.of(context).size.height;
    double sW = MediaQuery.of(context).size.width;
    return TextField(
      obscureText: obsureText,
      controller: controller,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        color: AppColors.primaryTextColor, // Set the input text color to white
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: hintText,
        hintStyle: TextStyle(
          color: AppColors.primaryTextColor,
        ),
        labelStyle: TextStyle(
          fontSize: sW * 0.035,
          color: AppColors.primaryTextColor,
        ),
        alignLabelWithHint: true,
        errorText: validate ? null : "Enter the title",
      ),
    );
  }
}
