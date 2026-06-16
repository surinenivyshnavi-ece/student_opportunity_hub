import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTeamFormationPage extends StatefulWidget {
  const AddTeamFormationPage({super.key});

  @override
  State<AddTeamFormationPage> createState() => _AddTeamFormationPageState();
}

class _AddTeamFormationPageState extends State<AddTeamFormationPage> {

  final teamNameController = TextEditingController();
  final skillController = TextEditingController();
  final membersController = TextEditingController();
  final contactController = TextEditingController();


  Future<void> addTeam() async {

    await FirebaseFirestore.instance
        .collection('team_formations')
        .add({

      'team name': teamNameController.text,
      'requiredSkill': skillController.text,
      'membersNeeded': membersController.text,
      'contact': contactController.text,

    });


    Navigator.pop(context);

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Team Formation"),
      ),


      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [


            TextField(

              controller: teamNameController,

              decoration: const InputDecoration(
                labelText: "Team Name",
              ),

            ),


            TextField(

              controller: skillController,

              decoration: const InputDecoration(
                labelText: "Required Skill",
              ),

            ),


            TextField(

              controller: membersController,

              decoration: const InputDecoration(
                labelText: "Members Needed",
              ),

            ),


            TextField(

              controller: contactController,

              decoration: const InputDecoration(
                labelText: "Contact",

              ),

            ),


            const SizedBox(height: 20),


            ElevatedButton(

              onPressed: addTeam,

              child: const Text("Save"),

            ),


          ],

        ),

      ),

    );

  }

}