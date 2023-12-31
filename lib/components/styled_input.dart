import 'package:flutter/material.dart';

class StyledInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isPassword;
  final bool isDisabled;
  final String? Function(String?)? validatorFn;
  final void Function(String)? handleChange;

  const StyledInput({
    super.key,
    required this.controller,
    required this.hint,
    this.validatorFn,
    this.handleChange,
    this.isPassword = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: handleChange,
      autocorrect: false,
      controller: controller,
      validator: validatorFn,
      obscureText: isPassword,
      enabled: !isDisabled,
      readOnly: isDisabled,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
        contentPadding: Theme.of(context).inputDecorationTheme.contentPadding,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        filled: Theme.of(context).inputDecorationTheme.filled,
        border: Theme.of(context).inputDecorationTheme.border,
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
        disabledBorder: Theme.of(context).inputDecorationTheme.disabledBorder,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
