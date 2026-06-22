import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTeamFormationPage extends StatefulWidget {
  const AddTeamFormationPage({super.key});

  @override
  State<AddTeamFormationPage> createState() =>
      _AddTeamFormationPageState();
}

class _AddTeamFormationPageState
    extends State<AddTeamFormationPage> {

  final teamNameController = TextEditingController();
  final skillController = TextEditingController();
  final membersController = TextEditingController();
  final deadlineController = TextEditingController();
  final contactController = TextEditingController();
  final descriptionController = TextEditingController();

  Future<void> addTeam() async {

    await FirebaseFirestore.instance
        .collection('team_formations')
        .add({

      'team name': teamNameController.text.trim(),

      'requiredSkill': skillController.text.trim(),

      'membersNeeded': membersController.text.trim(),

      'deadline': deadlineController.text.trim(),

      'contact': contactController.text.trim(),

      'description': descriptionController.text.trim(),

    });

    Navigator.pop(context);

  }

  @override
  void dispose() {
    teamNameController.dispose();
    skillController.dispose();
    membersController.dispose();
    deadlineController.dispose();
    contactController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Team Formation"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(
              controller: teamNameController,
              decoration: const InputDecoration(
                labelText: "Team Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: skillController,
              decoration: const InputDecoration(
                labelText: "Required Skill",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: membersController,
              decoration: const InputDecoration(
                labelText: "Members Needed",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(
                labelText: "Deadline",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: "Contact",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addTeam,
                child: const Text("Save"),
              ),
            ),

          ],

        ),

      ),

    );

  }

}