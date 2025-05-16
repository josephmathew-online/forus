import 'package:flutter/material.dart';

class TwoContainer extends StatelessWidget {
  final Function(int) onCategorySelected;
  final int selectedIndex;
  final Widget searchBar; // Add SearchBarChat as a widget

  TwoContainer({
    super.key,
    required this.onCategorySelected,
    required this.selectedIndex,
    required this.searchBar, // Accept searchBar
  });

  final List<String> categories = [
    'Messages',
    'Groups',
    'Online',
    'Calls',
    'Requests'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        searchBar, // Display the search bar at the top
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Container(
            height: 50.0,
            color: const Color(0xFFD2DCEE),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => onCategorySelected(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 14.0),
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: selectedIndex == index
                            ? const Color(0xFF7997CD) // Selected color
                            : Colors.grey, // Default color
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
