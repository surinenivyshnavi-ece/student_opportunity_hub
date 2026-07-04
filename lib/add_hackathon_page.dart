import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddHackathonPage extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? hackathonData;

  const AddHackathonPage({
    super.key,
    this.documentId,
    this.hackathonData,
  });

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

  @override
  void initState() {
    super.initState();

    if (widget.hackathonData != null) {
      titleController.text =
          widget.hackathonData!['title'] ?? '';

      organizerController.text =
          widget.hackathonData!['organizer'] ?? '';

      domainController.text =
          widget.hackathonData!['domain'] ?? '';

      locationController.text =
          widget.hackathonData!['location'] ?? '';

      modeController.text =
          widget.hackathonData!['mode'] ?? '';

      teamSizeController.text =
          widget.hackathonData!['teamSize'] ?? '';

      eligibilityController.text =
          widget.hackathonData!['eligibility'] ?? '';

      registrationFeeController.text =
          widget.hackathonData!['registrationFee'] ?? '';

      deadlineController.text =
          widget.hackathonData!['deadline'] ?? '';

      prizeController.text =
          widget.hackathonData!['prize'] ?? '';

      descriptionController.text =
          widget.hackathonData!['description'] ?? '';

      linkController.text =
          widget.hackathonData!['link'] ?? '';
    }
  }

  Future<void> addHackathon() async {
    if (titleController.text.trim().isEmpty ||
        organizerController.text.trim().isEmpty ||
        deadlineController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields"),
        ),
      );
      return;
    }

    final  Map<String, dynamic>hackathonData = {
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
    };

    if (widget.documentId == null) {

      hackathonData['createdAt'] =
          FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('hackathons')
          .add(hackathonData);
      await http.post(
        Uri.parse(
          "https://student-opportunity-hub-4hkx.onrender.com/sendNotification",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "title": "🚀 New Hackathon",
          "body":
          "${organizerController.text.trim()} has announced ${titleController.text.trim()}.",
        }),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hackathon added successfully"),
        ),
      );

    } else {

      await FirebaseFirestore.instance
          .collection('hackathons')
          .doc(widget.documentId)
          .update(hackathonData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Hackathon updated successfully"),
        ),
      );
    }

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
        title: Text(
          widget.documentId == null
              ? "Add Hackathon"
              : "Edit Hackathon",
        ),
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
                child: Text(
                  widget.documentId == null
                      ? "Save Hackathon"
                      : "Update Hackathon",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}