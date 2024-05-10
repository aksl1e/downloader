import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedDownloadingText extends StatelessWidget {
  const AnimatedDownloadingText(this.text, this.widgetKey, {super.key});

  final String text;
  final Key widgetKey;

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      key: widgetKey,
      animatedTexts: [
        TyperAnimatedText(
          '$text',
          textStyle: Theme.of(context).textTheme.headlineMedium,
          speed: Duration(milliseconds: 75),
        )
      ],
      repeatForever: true,
      pause: Duration(seconds: 2),
    );
  }
}
