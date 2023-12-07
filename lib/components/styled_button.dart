import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final void Function() handlePress;
  final String text;

  const StyledButton({
    super.key,
    required this.handlePress,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: handlePress,
      style: Theme.of(context).filledButtonTheme.style!.copyWith(
            fixedSize: const MaterialStatePropertyAll(
              Size.fromWidth(double.maxFinite),
            ),
          ),
      child: Text(text),
    );
  }
}
