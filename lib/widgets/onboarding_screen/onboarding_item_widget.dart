import 'package:flutter/material.dart';

class OnboardingItem extends StatelessWidget {
  const OnboardingItem({
    super.key,
    required this.text,
    required this.imagePath,
    this.italicRanges,
  });

  final String text;
  final String imagePath;
  final List<List<int>>? italicRanges;

  RichText _getItalicizedText(String inputText, List<List<int>>? italicRanges) {
    TextStyle normalStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    TextStyle italicStyle = const TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
    );

    List<InlineSpan> textSpans = [];

    int previousIndex = 0;

    if (italicRanges != null) {
      for (var range in italicRanges) {
        int startIndex = range[0];
        int endIndex = range[1];

        if (startIndex > previousIndex) {
          textSpans.add(
            TextSpan(
              text: inputText.substring(previousIndex, startIndex),
              style: normalStyle,
            ),
          );
        }

        textSpans.add(
          TextSpan(
            text: inputText.substring(startIndex, endIndex),
            style: italicStyle,
          ),
        );

        previousIndex = endIndex;
      }
    }

    if (previousIndex < inputText.length) {
      textSpans.add(
        TextSpan(
          text: inputText.substring(previousIndex),
          style: normalStyle,
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: textSpans),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath),
        const SizedBox(
          height: 22,
        ),
        _getItalicizedText(text, italicRanges),
      ],
    );
  }
}
