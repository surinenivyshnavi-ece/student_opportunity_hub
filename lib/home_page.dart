import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'internships_page.dart';
import 'hackathons_page.dart';
import 'team formation_page.dart';
import 'profile_page.dart';
import 'bookmarks_page.dart';
import 'feedback_page.dart';
import 'certification_page.dart';
import 'workshops_page.dart';
import 'events_page.dart';
class HomePage extends StatelessWidget {


  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //drawer: const AppDrawer(),

      backgroundColor: const Color(0xFFE9F5DB),


      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Student Opportunity Hub",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: PopupMenuButton<String>(
          icon: const Icon(
            Icons.account_circle,
            size: 30,
            color: Colors.black,
          ),
          onSelected: (value) async {
            if (value == "profile") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(),
                ),
              );
            }

            else if (value == "bookmarks") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const BookmarksPage(),
                ),
              );
            }

            else if (value == "feedback") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FeedbackPage(),
                ),
              );
            }

            else if (value == "settings") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Settings coming soon"),
                ),
              );
            }

            else if (value == "logout") {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text(
                    "Are you sure you want to logout?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
              }
            }
          },
          itemBuilder: (context) =>
          [
            const PopupMenuItem(
              value: "profile",
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text("Profile"),
                ],
              ),
            ),

            const PopupMenuItem(
              value: "bookmarks",
              child: Row(
                children: [
                  Icon(Icons.bookmark),
                  SizedBox(width: 10),
                  Text("Bookmarks"),
                ],
              ),
            ),

            const PopupMenuItem(
              value: "feedback",
              child: Row(
                children: [
                  Icon(Icons.feedback),
                  SizedBox(width: 10),
                  Text("Feedback"),
                ],
              ),
            ),

            const PopupMenuItem(
              value: "settings",
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 10),
                  Text("Settings"),
                ],
              ),
            ),

            const PopupMenuItem(
              value: "logout",
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 10),
                  Text("Logout"),
                ],
              ),
            ),
          ],
        ),
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [

            // Top Banner
            Stack(
              clipBehavior: Clip.none,
              children: [

                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35),
                  ),
                  child: SizedBox(
                    height: 220,
                    width: double.infinity,
                    child: Image.asset(
                      "assets/images/banner.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  bottom: -40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 44,
                        backgroundImage: AssetImage("assets/images/logo.png"),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 45),

            const Text(
              "Welcome to\nStudent Opportunity Hub",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Discover internships, hackathons, jobs, certifications and more—all in one place.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: .95,
                children: [

                  buildHomeCard(
                    context,
                    "Internships",
                    Icons.school,
                    Colors.green,
                    const InternshipsPage(),
                  ),

                  buildHomeCard(
                    context,
                    "Hackathons",
                    Icons.emoji_events,
                    Colors.orange,
                    const HackathonsPage(),
                  ),

                  buildHomeCard(
                    context,
                    "Team",
                    Icons.groups,
                    Colors.blue,
                    const TeamFormationPage(),
                  ),

                  buildHomeCard(
                    context,
                    "Certificates",
                    Icons.workspace_premium,
                    Colors.deepPurple,
                    const CertificationPage(),
                  ),

                  buildHomeCard(
                    context,
                    "Workshops",
                    Icons.menu_book,
                    Colors.red,
                    const WorkshopsPage(),
                  ),

                  buildHomeCard(
                    context,
                    "Events",
                    Icons.event,
                    Colors.teal,
                    const EventsPage(),
                  ),
                ],
              ),
            ),


// 👇 Add this here
            const SizedBox(height: 30),

            const Text(
              "Built by Team Student Opportunity Hub",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 15),

          ],
        ),
      ),
    );
  }

  Widget buildHomeCard(BuildContext context,
      String title,
      IconData icon,
      Color color,
      Widget page,) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}