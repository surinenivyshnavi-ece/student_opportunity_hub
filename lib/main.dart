import 'package:flutter/material.dart';
import 'internships_page.dart';
import 'hackathons_page.dart';
import 'team formation_page.dart';
import 'profile_page.dart';
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
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Student Opportunity Hub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              " 🎓Welcome to Student Opportunity Hub",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Find internships, hackathons, teammates and opportunities.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 25),

            buildButton(context, "📚 Internships", const InternshipsPage()),
            const SizedBox(height: 15),

            buildButton(context, "🏆 Hackathons", const HackathonsPage()),
            const SizedBox(height: 15),

            buildButton(context, "👥 Team Formation", const TeamPage()),
            const SizedBox(height: 15),

            buildButton(context, "👤 Profile", const ProfilePage()),

            const SizedBox(height: 30),

            const Text(
              "Built by Team Student Opportunity Hub",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context, String text, Widget page) {
    return Center(
        child: SizedBox(
          width: 280,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 4,
              padding: const EdgeInsets.all(18),
            ),

        onPressed: () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child:  Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    ),
      ),
        ),
    );
  }
}

