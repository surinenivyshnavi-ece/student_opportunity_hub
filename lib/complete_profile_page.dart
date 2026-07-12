import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pending_verification_page.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {

  final nameController = TextEditingController();
  final collegeController = TextEditingController();
  final branchController = TextEditingController();
  final yearController = TextEditingController();
  final rollController = TextEditingController();
  final phoneController = TextEditingController();

  bool loading = false;


  Future<void> saveProfile() async {
    setState(() {
      loading = true;
    });

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set({

        "name": nameController.text.trim(),
        "college": collegeController.text.trim(),
        "branch": branchController.text.trim(),
        "year": yearController.text.trim(),
        "rollNo": rollController.text.trim(),
        "phone": phoneController.text.trim(),

        "profileCompleted": true,
        "verified": false,
        "status": "pending",
        "rejectionReason": "",

      }, SetOptions(merge: true));

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const PendingVerificationPage(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }



  Widget buildField(
      String hint,
      TextEditingController controller){

    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Complete Profile"),
      ),


      body: SingleChildScrollView(

        child: Column(

          children: [

            buildField("Name", nameController),

            buildField("College", collegeController),

            buildField("Branch", branchController),

            buildField("Year", yearController),

            buildField("Roll Number", rollController),

            buildField("Phone", phoneController),


            const SizedBox(height:20),


            ElevatedButton(

              onPressed:
              loading ? null : saveProfile,

              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Save Profile"),

            )

          ],

        ),

      ),

    );

  }
}