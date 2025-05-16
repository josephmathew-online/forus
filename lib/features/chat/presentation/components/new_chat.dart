import 'package:flutter/material.dart';

class NewChat extends StatelessWidget {
  final VoidCallback onPressed;

  const NewChat({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Color(0xFF7997CD), // Match theme color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Icon(Icons.chat, color: Colors.white, size: 28),
    );
  }
}
