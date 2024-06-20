import 'package:flutter/material.dart';

class DynamicBoldText extends StatelessWidget {
  final String text;
  final String boldText;
  final TextStyle regularStyle;

  DynamicBoldText({
    required this.text,
    required this.boldText,
    required this.regularStyle,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];

    // Split the text based on the boldText
    final parts = text.split(boldText);
    for (int i = 0; i < parts.length; i++) {
      spans.add(TextSpan(text: parts[i], style: regularStyle));
      if (i < parts.length - 1) {
        spans.add(TextSpan(
          text: boldText,
          style: regularStyle.copyWith(fontWeight: FontWeight.bold),
        ));
      }
    }

    return Text.rich(
      TextSpan(children: spans),
    );
  }
}
