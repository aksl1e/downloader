import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class AnimatedDownloadingText extends StatelessWidget {
  const AnimatedDownloadingText({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TyperAnimatedText(
          'Downloading...',
          textStyle: Theme.of(context).textTheme.headlineMedium,
          speed: Duration(milliseconds: 100),
        )
      ],
      repeatForever: true,
      pause: Duration(seconds: 2),
    );
  }
}
