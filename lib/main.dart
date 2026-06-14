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
      backgroundColor: Colors.white, // removed grey/blue background

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Student Opportunity Hub',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// LOGO
                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                ),

                const SizedBox(height: 15),

                /// TITLE
                const Text(
                  "🎓 Welcome to Student Opportunity Hub",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                /// DESCRIPTION
                const Text(
                  "Find internships, hackathons, teammates and opportunities.",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                /// BUTTONS
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
        ),
      ),
    );
  }

  /// ================= BUTTON WIDGET =================
  Widget buildButton(
      BuildContext context,
      String text,
      Widget page,
      ) {
    return SizedBox(
      width: 280,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // PURE WHITE BUTTON
          foregroundColor: Colors.black,
          elevation: 3,
          padding: const EdgeInsets.all(18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.grey),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}