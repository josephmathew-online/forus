import 'package:flutter/material.dart';

class Google extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final String? assetIcon; // Asset image path instead of IconData

  const Google({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFD2DCEE),
    this.textColor = Colors.black,
    this.assetIcon = ("lib/images/icons/Google.png"), // Accept asset image path
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (assetIcon != null) // Show asset icon if provided
            Image.asset(
              assetIcon!,
              width: 20, // Adjust icon size as needed
              height: 20,
            ),
          const SizedBox(
            width: 8,
          ),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
