import 'package:flutter/material.dart';

class StyledInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validatorFn;

  const StyledInput({
    super.key,
    required this.controller,
    required this.hint,
    this.validatorFn,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      controller: controller,
      validator: validatorFn,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
        contentPadding: Theme.of(context).inputDecorationTheme.contentPadding,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        filled: Theme.of(context).inputDecorationTheme.filled,
        border: Theme.of(context).inputDecorationTheme.border,
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
