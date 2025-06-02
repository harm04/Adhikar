import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obsecureText;
  final int? maxLines;
  final int? maxLength;
  const CustomTextfield(
      {super.key,
      required this.controller,
      required this.hintText,this.maxLines,this.maxLength,
      required this.obsecureText, required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines ?? 1,
       textCapitalization: TextCapitalization.sentences,
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
        obscureText: obsecureText,
      decoration: InputDecoration(
        hintText: hintText,
     
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}