import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  final Function(int) onCategorySelected; // Callback function

  const CategorySelector({super.key, required this.onCategorySelected});

  @override
  // ignore: library_private_types_in_public_api
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;
  final List<String> categories = ['Messages', 'Groups', 'Online', 'Requests'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        height: 50.0,
        color: const Color(0xFFD2DCEE),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: Colors
                  .transparent, // Transparent background for splash effect
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onCategorySelected(index); // Notify parent widget
                },
                borderRadius:
                    // BorderRadius.circular(50.0), // Rounded splash effect
                    BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                splashColor: Color(0xFFC3D0E9), // Splash color effect
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 14.0),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: selectedIndex == index
                          ? Color(0xFF7997CD)
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
