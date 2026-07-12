import 'package:flutter/material.dart';
import 'admin_requests_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'manage_college_admins_page.dart';

class SuperAdminDashboard extends StatelessWidget {
  const SuperAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Super Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              "Welcome, Super Admin 👋",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),


            // Statistics cards
            Row(
              children: [

                Expanded(
                  child: _buildCard(
                    "Students",
                    "0",
                    Icons.people,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildCard(
                    "Admins",
                    "0",
                    Icons.admin_panel_settings,
                  ),
                ),

              ],
            ),


            const SizedBox(height: 12),


            Row(
              children: [

                Expanded(
                  child: _buildCard(
                    "Internships",
                    "0",
                    Icons.work,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildCard(
                    "Hackathons",
                    "0",
                    Icons.emoji_events,
                  ),
                ),

              ],
            ),


            const SizedBox(height: 30),


            const Text(
              "Management",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),


            const SizedBox(height: 15),


            _buildButton(
              context,
              "Manage Admin Requests",
              Icons.person_add,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const AdminRequestsPage(),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context)=>
                    const ManageCollegeAdminsPage(),
                  ),
                );
              },
              child: const Text("Manage College Admins"),
            ),


            _buildButton(
              context,
              "Manage Students",
              Icons.people_alt,
                  () {
                // We'll add the page later
              },
            ),

            _buildButton(
              context,
              "Manage Content",
              Icons.dashboard_customize,
                  () {
                // We'll add the page later
              },
            ),

          ],
        ),
      ),
    );
  }



  Widget _buildCard(
      String title,
      String value,
      IconData icon,
      ) {

    return Card(

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            Icon(
              icon,
              size: 35,
            ),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(title),

          ],
        ),
      ),
    );
  }



  Widget _buildButton(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onTap,
      ) {

    return Card(

      child: ListTile(

        leading: Icon(icon),

        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
        ),

        onTap: onTap,

      ),
    );
  }

}