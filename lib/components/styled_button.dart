import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final void Function() handlePress;
  final String text;
  final String? type;
  final Icon? icon;

  const StyledButton({
    super.key,
    required this.handlePress,
    required this.text,
    this.type,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'secondary':
        return OutlinedButton(
          onPressed: handlePress,
          style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                fixedSize: const MaterialStatePropertyAll(
                  Size.fromWidth(double.maxFinite),
                ),
                foregroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(117, 157, 234, 1),
                ),
                side: MaterialStateProperty.all(
                  const BorderSide(
                    color: Color.fromRGBO(117, 157, 234, 1),
                  ),
                ),
              ),
          child: Stack(
            children: [
              Center(
                child: Text(text),
              ),
              Container(
                child: icon,
              ),
            ],
          ),
        );
      case 'discard':
        return OutlinedButton(
          onPressed: handlePress,
          style: Theme.of(context).outlinedButtonTheme.style!.copyWith(
                fixedSize: const MaterialStatePropertyAll(
                  Size.fromWidth(double.maxFinite),
                ),
                foregroundColor: MaterialStateProperty.all(
                  const Color.fromRGBO(234, 117, 117, 1),
                ),
                side: MaterialStateProperty.all(
                  const BorderSide(
                    color: Color.fromRGBO(234, 117, 117, 1),
                  ),
                ),
              ),
          child: Stack(
            children: [
              Center(
                child: Text(text),
              ),
              Container(
                child: icon,
              ),
            ],
          ),
        );
      default:
        return FilledButton(
          onPressed: handlePress,
          style: Theme.of(context).filledButtonTheme.style!.copyWith(
                fixedSize: const MaterialStatePropertyAll(
                  Size.fromWidth(double.maxFinite),
                ),
              ),
          child: Stack(
            children: [
              Center(
                child: Text(text),
              ),
              Container(
                child: icon,
              ),
            ],
          ),
        );
    }
  }
}
