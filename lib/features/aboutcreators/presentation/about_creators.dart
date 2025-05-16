import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text("About the Creator"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          // Add scroll view to prevent overflow
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                "Meet the Team",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Member 1
              _buildMemberInfo(
                'lib/images/members/member1.jpg', // Replace with member 1's image
                'Abhinav M Rajesh',
                'I am a full-stack developer and team leader, driving the development of 4us.',
              ),
              SizedBox(height: 20),

              // Member 2
              _buildMemberInfo(
                'lib/images/members/member2.jpg', // Replace with member 2's image
                'Abel Mathew Cherian',
                'I am a UI developer for 4us, focused on creating intuitive and visually appealing interfaces.',
              ),
              SizedBox(height: 20),

              // Member 3
              _buildMemberInfo(
                'lib/images/members/member3.jpg', // Replace with member 3's image
                'Adarsh P',
                'I am a database expert for 4us, managing data seamlessly for optimal performance.',
              ),
              SizedBox(height: 20),

              // Member 4
              _buildMemberInfo(
                'lib/images/members/member4.jpg', // Replace with member 4's image
                'Cherish Mathew Joseph',
                'I am a frontend developer for 4us, with a keen eye for design, ensuring smooth and responsive user experiences.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create member info section
  Widget _buildMemberInfo(String imagePath, String name, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Member's Image
        CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(width: 16),
        // Member's Name and Description
        Expanded(
          // Ensures the text expands within the available space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
