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

      body: StreamBuilder<DocumentSnapshot>(
        stream: profilesRef.doc('user_profile').snapshots(),
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

          if (!snapshot.data!.exists) {
            return const Center(
              child: Text("No profile found"),
            );
          }

          final data =
          snapshot.data!.data()
          as Map<String, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 10),

              CircleAvatar(
                radius: 50,
                backgroundImage:
                (data['profilePhotoUrl'] ?? '').toString().isNotEmpty
                    ? NetworkImage(data['profilePhotoUrl'])
                    : null,
                child:
                (data['profilePhotoUrl'] ?? '').toString().isEmpty
                    ? const Icon(
                  Icons.person,
                  size: 50,
                )
                    : null,
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
                  leading: const Icon(Icons.location_city),
                  title: Text(
                    data['city'] ?? '',
                  ),
                  subtitle: const Text("City"),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.psychology),
                  title: Text(
                    data['skills'] != null
                        ? (data['skills'] as List).join(', ')
                        : '',
                  ),
                  subtitle: const Text("Skills"),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(
                    data['aboutMe'] ?? '',
                  ),
                  subtitle: const Text("About Me"),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.code),
                  title: Text(
                    data['githubLink'] ?? '',
                  ),
                  subtitle: const Text("GitHub"),
                ),
              ),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.work),
                  title: Text(
                    data['linkedInLink'] ?? '',
                  ),
                  subtitle: const Text("LinkedIn"),
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