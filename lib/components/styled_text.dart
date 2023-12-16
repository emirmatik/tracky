import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  final Color? color;
  final String? type;

  const StyledText({
    super.key,
    required this.text,
    this.type,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'h1':
        return Text(
          text,
          style:
              Theme.of(context).textTheme.displayLarge!.copyWith(color: color),
        );
      case 'h2':
        return Text(
          text,
          style:
              Theme.of(context).textTheme.displayMedium!.copyWith(color: color),
        );
      case 'h3':
        return Text(
          text,
          style:
              Theme.of(context).textTheme.displaySmall!.copyWith(color: color),
        );
      case 'h4':
        return Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: color),
        );
      case 'small':
        return Text(
          text,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: color),
        );
      default:
        return Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: color),
        );
    }
  }
}
