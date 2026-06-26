import 'package:flutter/material.dart';
import 'internships_page.dart';
import 'hackathons_page.dart';
import 'team formation_page.dart';
import 'profile_page.dart';
import 'bookmarks_page.dart';
import 'certification_page.dart';
import 'events_page.dart';
import 'workshops_page.dart';
import 'feedback_page.dart';


class AppDrawer extends StatelessWidget {

  const AppDrawer({super.key});


  @override
  Widget build(BuildContext context) {


    return Drawer(

      child: ListView(

        children: [


          const DrawerHeader(

            child: Text(

              "Student Opportunity Hub",

              style: TextStyle(

                fontSize:22,

                fontWeight: FontWeight.bold,

              ),

            ),

          ),



          ListTile(

            leading: const Icon(Icons.work),

            title: const Text("Internships"),

            onTap: (){

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(context)=>const InternshipsPage(),

                ),

              );

            },

          ),



          ListTile(

            leading: const Icon(Icons.emoji_events),

            title: const Text("Hackathons"),

            onTap: (){

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(context)=>const HackathonsPage(),

                ),

              );

            },

          ),



          ListTile(

            leading: const Icon(Icons.group),

            title: const Text("Team Formation"),

            onTap: (){

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(context)=>const TeamFormationPage(),

                ),

              );

            },

          ),



          ListTile(

            leading: const Icon(Icons.bookmark),

            title: const Text("Bookmarks"),

            onTap: (){

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(context)=>const BookmarksPage(),

                ),

              );

            },

          ),



          ListTile(

            leading: const Icon(Icons.person),

            title: const Text("Profile"),

            onTap: (){

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(context)=>ProfilePage(),

                ),

              );

            },

          ),



          const Divider(),



          ListTile(

            leading: const Icon(Icons.event),

            title: const Text("Events"),

            onTap: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (context) => const EventsPage(),

                ),

              );

            },

          ),



          ListTile(

            leading: const Icon(Icons.school),

            title: const Text("Workshops & Webinars"),

            onTap: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (context) => const WorkshopsPage(),

                ),

              );

            },

          ),



          ListTile(

            leading: const Icon(Icons.workspace_premium),

            title: const Text("Certification Courses"),

            onTap: (){

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(context)=>
                  const CertificationPage(),

                ),

              );

            },

          ),



          ListTile(

            leading: const Icon(Icons.feedback),

            title: const Text("Feedback"),

            onTap: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (context) => const FeedbackPage(),

                ),

              );

            },

          ),


        ],


      ),


    );


  }

}