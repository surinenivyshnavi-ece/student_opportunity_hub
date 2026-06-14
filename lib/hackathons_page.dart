import 'package:flutter/material.dart';

class HackathonsPage extends StatelessWidget {
  const HackathonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hackathons")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.emoji_events),
              title: Text("Smart India Hackathon"),
              subtitle: Text("National-level innovation competition"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.computer),
              title: Text("Google Solution Challenge"),
              subtitle: Text("Build solutions using Google technologies"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.engineering),
              title: Text("IEEE Hackathon"),
              subtitle: Text("Engineering and technology challenges"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text("Startup Idea Challenge"),
              subtitle: Text("Present innovative startup ideas"),
            ),
          ),
        ],
      ),
    );
  }
}
