import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// ================= APP ROOT =================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Opportunity Hub',
      home: const HomePage(),
    );
  }
}

/// ================= HOME PAGE =================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Opportunity Hub'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildButton(context, "Internships", const InternshipsPage()),
            const SizedBox(height: 15),
            buildButton(context, "Hackathons", const HackathonsPage()),
            const SizedBox(height: 15),
            buildButton(context, "Team Formation", const TeamPage()),
            const SizedBox(height: 15),
            buildButton(context, "Profile", const ProfilePage()),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, Widget page) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(text),
      ),
    );
  }
}

/// ================= INTERNSHIPS PAGE =================
class InternshipsPage extends StatelessWidget {
  const InternshipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Internships")),
      body: const Center(
        child: Text(
          "Internship Listings Coming Soon",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

/// ================= HACKATHONS PAGE =================
class HackathonsPage extends StatelessWidget {
  const HackathonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hackathons")),
      body: const Center(
        child: Text(
          "Hackathon Events Coming Soon",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

/// ================= TEAM FORMATION PAGE =================
class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Team Formation")),
      body: const Center(
        child: Text(
          "Find Teammates Coming Soon",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

/// ================= PROFILE PAGE =================
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(
        child: Text(
          "User Profile Coming Soon",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}