import 'package:flutter/material.dart';
import 'student_verification_page.dart';
import 'manage_internships_page.dart';
import 'manage_hackathons_page.dart';
import 'manage_events_page.dart';
import 'manage_workshops_page.dart';
import 'manage_certifications_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'login_page.dart';
import 'team formation_page.dart';


class CollegeAdminHomePage extends StatelessWidget {
  const CollegeAdminHomePage({super.key});
  Future<void> logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text(
          "Are you sure you want to logout?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("College Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () {
              logout(context);
            },
          ),
        ],
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
              subtitle: const Text("Add, Edit & Delete Internships"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageInternshipsPage(),
                  ),
                );
              },
            ),
          ),

          Card(
             child : ListTile(
              leading: const Icon(Icons.emoji_events),
              title: const Text("Manage Hackathons"),
              subtitle: const Text("Add, Edit & Delete Hackathons"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageHackathonsPage(),
                  ),
                );
              },
            ),
          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: const Text("Manage Events"),
              subtitle: const Text("Add, Edit & Delete Events"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageEventsPage(),
                  ),
                );
              },
            ),

          ),

          Card(
            child: ListTile(
              leading: const Icon(Icons.school),
              title: const Text("Manage Workshops"),
              subtitle: const Text("Add, Edit & Delete Workshops"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageWorkshopsPage(),
                  ),
                );
              },
            ),
          ),
          Card (
            child: ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text("Manage Certifications"),
              subtitle: const Text("Add, Edit & Delete Certifications"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageCertificationsPage(),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.groups),
              title: const Text("Manage Team Formation"),
              subtitle: const Text("View, Edit & Delete Team Posts"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TeamFormationPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}