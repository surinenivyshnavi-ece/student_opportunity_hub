import 'package:flutter/material.dart';
import 'student_verification_page.dart';

class CollegeAdminHomePage extends StatelessWidget {
  const CollegeAdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("College Admin Dashboard"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Card(
            child: ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text("Student Verification"),
              subtitle: const Text("Approve or reject students"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudentVerificationPage(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.work),
              title: const Text("Manage Internships"),
              subtitle: const Text("Coming Soon"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text("Manage Hackathons"),
              subtitle: const Text("Coming Soon"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: const Text("Manage Events"),
              subtitle: const Text("Coming Soon"),
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.school),
              title: const Text("Manage Workshops"),
              subtitle: const Text("Coming Soon"),
            ),
          ),
        ],
      ),
    );
  }
}