import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obsecureText;
  final int? maxLines;
  final TextCapitalization textCapitalization;
  final int? maxLength;
  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines,
    this.maxLength,
    required this.textCapitalization,
    required this.obsecureText,
    required this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines ?? 1,
      textCapitalization: textCapitalization,
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
      obscureText: obsecureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
