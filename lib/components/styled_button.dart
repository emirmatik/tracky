import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final void Function()? handlePress;
  final String text;
  final String? type;
  final dynamic icon;

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
                side: MaterialStateProperty.all(
                  handlePress == null
                      ? const BorderSide(
                          color: Color.fromRGBO(117, 157, 234, 0.5),
                        )
                      : null,
                ),
              ),
          child: Stack(
            alignment: const Alignment(-1, 0),
            children: [
              Center(
                child: Text(text),
              ),
              icon ?? Container(),
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
                  handlePress == null
                      ? const Color.fromRGBO(234, 117, 117, 0.5)
                      : const Color.fromRGBO(234, 117, 117, 1),
                ),
                side: MaterialStateProperty.all(
                  handlePress == null
                      ? const BorderSide(
                          color: Color.fromRGBO(234, 117, 117, 0.5),
                        )
                      : const BorderSide(
                          color: Color.fromRGBO(234, 117, 117, 1),
                        ),
                ),
              ),
          child: Center(
            child: Text(text),
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
            alignment: const Alignment(-1, 0),
            children: [
              Center(
                child: Text(text),
              ),
              icon ?? Container(),
            ],
          ),
        );
    }
  }
}
