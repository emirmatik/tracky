import 'package:flutter/material.dart';

class StyledInput extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final String hint;
  final String? Function(String?)? validatorFn;

  const StyledInput({
    super.key,
    required this.controller,
    required this.hint,
    this.validatorFn,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      controller: controller,
      validator: validatorFn,
      obscureText: isPassword,
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
