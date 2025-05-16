// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFC4D1E9),
            ),
            borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        fillColor: Color(0xFFD2DCEE),
        filled: true,
      ),
    );
  }
}
