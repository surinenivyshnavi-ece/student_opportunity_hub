import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentVerificationPage extends StatefulWidget {
  const StudentVerificationPage({super.key});

  @override
  State<StudentVerificationPage> createState() =>
      _StudentVerificationPageState();
}

class _StudentVerificationPageState extends State<StudentVerificationPage> {

  String? adminCollege;

  @override
  void initState() {
    super.initState();
    getAdminCollege();
  }


  Future<void> getAdminCollege() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No user is currently logged in.'),
            ),
          );
        }
        return;
      }

      final uid = user.uid;

      final adminDoc = await FirebaseFirestore.instance
          .collection("admins")
          .doc(uid)
          .get();

      if (!adminDoc.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'College admin profile was not found.',
              ),
            ),
          );
        }
        return;
      }

      final data = adminDoc.data();

      final college = data?['college'];

      if (college == null || college.toString().trim().isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'College information is missing from admin profile.',
              ),
            ),
          );
        }
        return;
      }

      if (mounted) {
        setState(() {
          adminCollege = college.toString();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error loading admin information: $e',
            ),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    if (adminCollege == null) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

    }


    return Scaffold(

      appBar: AppBar(
        title: const Text("Student Verifications"),
      ),


      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'student')
            .where('verified', isEqualTo: false)
            .where('college', isEqualTo: adminCollege)
            .snapshots(),
        builder: (context, snapshot) {

          // Still loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading students: ${snapshot.error}',
              ),
            );
          }

          // No students found
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 60,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'No Pending Student Verifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'All student profiles have been verified.',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // Students available
          final students = snapshot.data!.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];

              return ListTile(
                title: Text(student['name'] ?? 'Unknown Student'),
                subtitle: Text(student['email'] ?? ''),
              );
            },
          );
        },
      )

    );

  }
}