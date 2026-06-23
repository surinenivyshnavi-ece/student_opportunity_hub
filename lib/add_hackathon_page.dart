import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddHackathonPage extends StatefulWidget {
  const AddHackathonPage({super.key});

  @override
  State<AddHackathonPage> createState() =>
      _AddHackathonPageState();
}

class _AddHackathonPageState extends State<AddHackathonPage> {
  final titleController = TextEditingController();
  final organizerController = TextEditingController();
  final domainController = TextEditingController();
  final locationController = TextEditingController();
  final modeController = TextEditingController();
  final teamSizeController = TextEditingController();
  final eligibilityController = TextEditingController();
  final registrationFeeController = TextEditingController();
  final deadlineController = TextEditingController();
  final prizeController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  Future<void> addHackathon() async {
    if (titleController.text.trim().isEmpty ||
        organizerController.text.trim().isEmpty ||
        deadlineController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all required fields",
          ),
        ),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('hackathons')
        .add({
      'title': titleController.text.trim(),
      'organizer': organizerController.text.trim(),
      'domain': domainController.text.trim(),
      'location': locationController.text.trim(),
      'mode': modeController.text.trim(),
      'teamSize': teamSizeController.text.trim(),
      'eligibility': eligibilityController.text.trim(),
      'registrationFee':
      registrationFeeController.text.trim(),
      'deadline': deadlineController.text.trim(),
      'prize': prizeController.text.trim(),
      'description': descriptionController.text.trim(),
      'link': linkController.text.trim(),
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Hackathon added successfully",
        ),
      ),
    );

    Navigator.pop(context);

  }

  @override
  void dispose() {
    titleController.dispose();
    organizerController.dispose();
    domainController.dispose();
    locationController.dispose();
    modeController.dispose();
    teamSizeController.dispose();
    eligibilityController.dispose();
    registrationFeeController.dispose();
    deadlineController.dispose();
    prizeController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  Widget buildTextField(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
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
        title: const Text("Add Hackathon"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(
              titleController,
              "Hackathon Title",
            ),
            buildTextField(
              organizerController,
              "Organizer",
            ),
            buildTextField(
              domainController,
              "Domain",
            ),
            buildTextField(
              locationController,
              "Location",
            ),
            buildTextField(
              modeController,
              "Mode (Online/Offline)",
            ),
            buildTextField(
              teamSizeController,
              "Team Size",
            ),
            buildTextField(
              eligibilityController,
              "Eligibility",
            ),
            buildTextField(
              registrationFeeController,
              "Registration Fee",
            ),
            buildTextField(
              deadlineController,
              "Deadline",
            ),
            buildTextField(
              prizeController,
              "Prize Money",
            ),
            buildTextField(
              descriptionController,
              "Description",
              maxLines: 5,
            ),
            buildTextField(
              linkController,
              "Application Link",
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: addHackathon,
                child: const Text(
                  "Save Hackathon",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}