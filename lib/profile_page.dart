import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final CollectionReference profilesRef =
  FirebaseFirestore.instance.collection('profiles');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE3F2FD),

      appBar: AppBar(
        title: const Text("Profile"),

        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const EditProfilePage(),
                ),
              );
            },
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: profilesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text("No profile found"),
            );
          }

          final data =
          docs.first.data()
          as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 10),

              const CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),

              const SizedBox(height: 15),

              Center(
                child: Text(
                  data['name'] ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 5),

              Center(
                child: Text(
                  data['careerGoal'] ?? '',
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 20),

              Card(
                child: ListTile(
                  leading:
                  const Icon(Icons.school),
                  title: Text(
                    data['college'] ?? '',
                  ),
                  subtitle:
                  const Text("College"),
                ),
              ),

              Card(
                child: ListTile(
                  leading:
                  const Icon(Icons.memory),
                  title: Text(
                    data['branch'] ?? '',
                  ),
                  subtitle:
                  const Text("Branch"),
                ),
              ),

              Card(
                child: ListTile(
                  leading:
                  const Icon(Icons.calendar_today),
                  title: Text(
                    data['year'] ?? '',
                  ),
                  subtitle:
                  const Text("Year"),
                ),
              ),

              Card(
                child: ListTile(
                  leading:
                  const Icon(Icons.flag),
                  title: Text(
                    data['careerGoal'] ?? '',
                  ),
                  subtitle:
                  const Text("Career Goal"),
                ),
              ),
            ],
          );
        },
      ),
    );

  }
}