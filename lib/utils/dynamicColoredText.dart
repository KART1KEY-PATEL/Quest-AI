import 'package:flutter/material.dart';

class DynamicColoredText extends StatelessWidget {
  final String text;
  final List<String> coloredTexts;
  final TextStyle regularStyle;
  final TextStyle highlightedStyle;

  DynamicColoredText({
    required this.text,
    required this.coloredTexts,
    required this.regularStyle,
    required this.highlightedStyle,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];

    String remainingText = text;

    for (String coloredText in coloredTexts) {
      if (remainingText.contains(coloredText)) {
        int startIndex = remainingText.indexOf(coloredText);

        if (startIndex != 0) {
          spans.add(TextSpan(
              text: remainingText.substring(0, startIndex),
              style: regularStyle));
        }

        spans.add(TextSpan(text: coloredText, style: highlightedStyle));

        remainingText =
            remainingText.substring(startIndex + coloredText.length);
      }
    }

    spans.add(TextSpan(text: remainingText, style: regularStyle));

    return Text.rich(
      TextSpan(children: spans),
    );
  }
}
