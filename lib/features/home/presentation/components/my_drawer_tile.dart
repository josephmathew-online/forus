import 'package:flutter/material.dart';

class MyDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;

  const MyDrawerTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold),
      ),
      onTap: onTap,
    );
  }
}
