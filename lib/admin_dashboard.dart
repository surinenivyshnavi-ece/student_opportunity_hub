import 'package:flutter/material.dart';
import 'student_verification_page.dart';
import 'internships_page.dart';
import 'hackathons_page.dart';
import 'certification_page.dart';
import 'workshops_page.dart';
import 'events_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'team formation_page.dart';
import 'feedback_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StudentVerificationPage(),
                ),
              );
            },
            child: const Text("Student Verifications"),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const InternshipsPage(),
                ),
              );
            },
            child: const Text("Manage Internships"),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HackathonsPage(),
                ),
              );
            },
            child: const Text("Manage Hackathons"),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CertificationPage(),
                ),
              );
            },
            child: const Text("Manage Certifications"),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WorkshopsPage(),
                ),
              );
            },
            child: const Text("Manage Workshops"),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EventsPage(),
                ),
              );
            },
            child: const Text("Manage Events"),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TeamFormationPage(),
                ),
              );
            },
            child: const Text("Manage Team Formation"),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FeedbackPage(),
                ),
              );
            },
            child: const Text("View Feedback"),
          ),
          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}