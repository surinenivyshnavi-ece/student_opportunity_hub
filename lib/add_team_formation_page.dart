import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddTeamFormationPage extends StatefulWidget {

  final String? documentId;
  final Map<String, dynamic>? teamData;

  const AddTeamFormationPage({
    super.key,
    this.documentId,
    this.teamData,
  });

  @override
  State<AddTeamFormationPage> createState() =>
      _AddTeamFormationPageState();
}

class _AddTeamFormationPageState
    extends State<AddTeamFormationPage> {

  final teamNameController = TextEditingController();
  final requiredSkillController = TextEditingController();
  final preferredRoleController = TextEditingController();
  final membersNeededController = TextEditingController();
  final emailController = TextEditingController();
  final linkController = TextEditingController();

  bool lookingForTeam = true;
  bool availableForProjects = true;
  bool availableForHackathons = true;
  @override
  void initState() {
    super.initState();

    if (widget.teamData != null) {

      teamNameController.text =
          widget.teamData!['teamName'] ?? '';

      requiredSkillController.text =
          widget.teamData!['requiredSkill'] ?? '';

      preferredRoleController.text =
          widget.teamData!['preferredRole'] ?? '';

      membersNeededController.text =
          widget.teamData!['membersNeeded'] ?? '';

      emailController.text =
          widget.teamData!['email'] ?? '';

      linkController.text =
          widget.teamData!['link'] ?? '';

      lookingForTeam =
          widget.teamData!['lookingForTeam'] ?? true;

      availableForProjects =
          widget.teamData!['availableForProjects'] ?? true;

      availableForHackathons =
          widget.teamData!['availableForHackathons'] ?? true;
    }
  }
  Future<void> addTeam() async {
    try {
      if (teamNameController.text.trim().isEmpty ||
          requiredSkillController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please fill all required fields"),
          ),
        );
        return;
      }

      final teamData = {
        'teamName': teamNameController.text.trim(),
        'requiredSkill': requiredSkillController.text.trim(),
        'preferredRole': preferredRoleController.text.trim(),
        'membersNeeded': membersNeededController.text.trim(),
        'email': FirebaseAuth.instance.currentUser?.email ?? '',
        'link': linkController.text.trim(),
        'lookingForTeam': lookingForTeam,
        'availableForProjects': availableForProjects,
        'availableForHackathons': availableForHackathons,
        'createdBy': FirebaseAuth.instance.currentUser!.uid,
      };

      if (widget.documentId == null) {
        teamData['createdAt'] = FieldValue.serverTimestamp();

        await FirebaseFirestore.instance
            .collection('team_formations')
            .add(teamData);

        // Notification (optional)
        await http.post(
          Uri.parse(
            "https://student-opportunity-hub-4hkx.onrender.com/sendNotification",
          ),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "title": "👥 Team Formation",
            "body": "Team members are required for ${teamNameController.text.trim()}.",
            "screen":"teamformation",
          }),
        );
      } else {
        await FirebaseFirestore.instance
            .collection('team_formations')
            .doc(widget.documentId)
            .update(teamData);
      }

      if (!mounted) return;
      Navigator.pop(context, true);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    teamNameController.dispose();
    requiredSkillController.dispose();
    preferredRoleController.dispose();
    membersNeededController.dispose();
    emailController.dispose();
    linkController.dispose();
    super.dispose();
  }

  Widget buildTextField(
      TextEditingController controller,
      String label,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.documentId == null
              ? "Add Team Formation"
              : "Edit Team Formation",
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            buildTextField(
              teamNameController,
              "TeamName",
            ),

            buildTextField(
              requiredSkillController,
              "Required Skill",
            ),

            buildTextField(
              preferredRoleController,
              "Preferred Role",
            ),

            buildTextField(
              membersNeededController,
              "Members Needed",
            ),

            buildTextField(
              emailController,
              "Email",
            ),

            buildTextField(
              linkController,
              "Application/Contact Link",
            ),

            SwitchListTile(
              title: const Text(
                "Looking For Team",
              ),
              value: lookingForTeam,
              onChanged: (value) {
                setState(() {
                  lookingForTeam = value;
                });
              },
            ),

            SwitchListTile(
              title: const Text(
                "Available For Projects",
              ),
              value: availableForProjects,
              onChanged: (value) {
                setState(() {
                  availableForProjects = value;
                });
              },
            ),

            SwitchListTile(
              title: const Text(
                "Available For Hackathons",
              ),
              value: availableForHackathons,
              onChanged: (value) {
                setState(() {
                  availableForHackathons = value;
                });
              },
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: addTeam,
                child: Text(
                  widget.documentId == null
                      ? "Save Team Formation"
                      : "Update Team Formation",
                ),
              ),
            ),

          ],

        ),

      ),

    );

  }

}