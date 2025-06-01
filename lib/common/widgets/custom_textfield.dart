import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obsecureText;
  const CustomTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obsecureText, required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextField(
       textCapitalization: TextCapitalization.sentences,
      controller: controller,
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