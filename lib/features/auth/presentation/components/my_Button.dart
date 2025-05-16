import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.onTap, required this.text});
  final void Function()? onTap;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFC4D1E9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'Poppins'),
          ),
        ),
      ),
    );
  }
}
