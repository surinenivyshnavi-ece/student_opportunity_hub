import 'package:flutter/material.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Team Formation")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text("Embedded Systems Team"),
              subtitle: Text("Looking for 2 ECE students"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.groups),
              title: Text("Hackathon Team"),
              subtitle: Text("Need Flutter Developer"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.code),
              title: Text("AI Project Team"),
              subtitle: Text("Seeking ML enthusiasts"),
            ),
          ),

          Card(
            child: ListTile(
              leading: Icon(Icons.school),
              title: Text("GATE Study Group"),
              subtitle: Text("ECE students preparing for GATE"),
            ),
          ),
        ],
      ),
    );
  }
}
