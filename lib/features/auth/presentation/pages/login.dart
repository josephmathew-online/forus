import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final VoidCallback onTap;

  const Login({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5A6C57),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(horizontal: 160, vertical: 18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //icon space???
          SizedBox(width: 8),
          Text(
            "Login",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
