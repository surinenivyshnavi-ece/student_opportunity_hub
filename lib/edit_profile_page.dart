import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}


class _EditProfilePageState extends State<EditProfilePage> {

  final nameController = TextEditingController();
  final collegeController = TextEditingController();
  final branchController = TextEditingController();
  final yearController = TextEditingController();
  final careerGoalController = TextEditingController();


  Future<void> updateProfile() async {

    await FirebaseFirestore.instance
        .collection('profiles')
        .doc('user_profile')
        .set({

      'name': nameController.text,
      'college': collegeController.text,
      'branch': branchController.text,
      'year': yearController.text,
      'careerGoal': careerGoalController.text,

    });


    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content: Text("Profile updated successfully"),
      ),

    );


    Navigator.pop(context);

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),


      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [


            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),


            TextField(
              controller: collegeController,
              decoration: const InputDecoration(
                labelText: "College",
              ),
            ),


            TextField(
              controller: branchController,
              decoration: const InputDecoration(
                labelText: "Branch",
              ),
            ),


            TextField(
              controller: yearController,
              decoration: const InputDecoration(
                labelText: "Year",
              ),
            ),


            TextField(
              controller: careerGoalController,
              decoration: const InputDecoration(
                labelText: "Career Goal",
              ),
            ),


            const SizedBox(height:20),


            ElevatedButton(

              onPressed: updateProfile,

              child: const Text("Save"),

            ),

          ],

        ),

      ),

    );

  }

}