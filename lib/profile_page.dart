import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),

          SizedBox(height: 20),

          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text("Student Name"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.school),
              title: Text("Bhoj Reddy Engineering College"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.memory),
              title: Text("Electronics and Communication Engineering"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.flag),
              title: Text("Career Goals: Embedded Systems & GATE"),
            ),
          ),
        ],
      ),
    );
  }
}