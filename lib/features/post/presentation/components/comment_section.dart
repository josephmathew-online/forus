import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class CommentScreen extends StatefulWidget {
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> comments = [
    {
      "text": "This is awesome! 🚀",
      "time": DateFormat('hh:mm a').format(DateTime.now())
    },
    {
      "text": "Great job! Keep it up! 👍",
      "time": DateFormat('hh:mm a').format(DateTime.now())
    },
    {
      "text": "Really helpful, thanks!",
      "time": DateFormat('hh:mm a').format(DateTime.now())
    },
    {
      "text": "I totally agree with you!",
      "time": DateFormat('hh:mm a').format(DateTime.now())
    },
  ];

  // Generate a random color for avatars
  final List<Color> avatarColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal
  ];
  final Random random = Random();

  void showCommentsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5, // Opens at half screen
          minChildSize: 0.3, // Minimum height
          maxChildSize: 0.9, // Almost full screen
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      itemCount: comments.length,
                      separatorBuilder: (context, index) =>
                          Divider(thickness: 1, color: Colors.grey[300]),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: avatarColors[
                                random.nextInt(avatarColors.length)],
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(comments[index]["text"]!),
                          subtitle: Text(comments[index]["time"]!,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12)),
                        );
                      },
                    ),
                  ),
                  Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: "Write a comment...",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.blue),
                          onPressed: () {
                            if (_controller.text.isNotEmpty) {
                              setState(() {
                                comments.add({
                                  "text": _controller.text,
                                  "time": DateFormat('hh:mm a')
                                      .format(DateTime.now()),
                                });
                                _controller.clear();
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Post')),
      body: Center(
        child: ElevatedButton(
          onPressed: showCommentsSheet,
          child: Text('Show Comments'),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: CommentScreen()));
}
