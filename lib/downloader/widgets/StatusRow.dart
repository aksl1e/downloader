import 'package:flutter/material.dart';

class StatusRow extends StatelessWidget {
  const StatusRow(this.progress, this.timeRemainingAsString, {super.key});

  final double progress;
  final String timeRemainingAsString;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Progress: ${(progress * 100).toStringAsFixed(2)}%',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          'Time remaining: ${timeRemainingAsString}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}