import 'package:flutter/material.dart';

class SearchBarChat extends StatelessWidget {
  const SearchBarChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Container(
        height: 50, // Ensure enough height for visibility
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Color(0xFFC4D1E9), // Search bar background
          border: Border.all(
              color: Color(0xFFC4D1E9), width: 1), // Check if borders appear
          borderRadius: BorderRadius.circular(50), // Rounded edges
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey[700], size: 24),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey[700], fontSize: 16),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
