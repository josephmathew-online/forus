import 'package:flutter/material.dart';

class Composer extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  Composer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: 15.0, left: 10.0, right: 10.0), // Floating Effect
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0), // Capsule shape
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(0, 3), // Subtle shadow effect
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo,
                  color: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                // Implement photo picker
              },
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send,
                  color: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  // Handle sending message
                  _controller.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
