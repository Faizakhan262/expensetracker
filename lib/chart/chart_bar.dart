import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  const ChartBar({super.key, required this.fill});
  final double fill;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return FractionallySizedBox(
      heightFactor: fill,
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isDarkMode
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary.withOpacity(0.7),
        ),
      ),
    );
  }
}
