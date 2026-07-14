import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddInternshipPage extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? internshipData;


  const AddInternshipPage({
    super.key,
    this.documentId,
    this.internshipData,
  });

  @override
  State<AddInternshipPage> createState() =>
      _AddInternshipPageState();
}

class _AddInternshipPageState extends State<AddInternshipPage> {
  final companyController = TextEditingController();
  final titleController = TextEditingController();
  String selectedDomain = "Software Development";
  final locationController = TextEditingController();
  String selectedMode = "Online";
  final durationController = TextEditingController();
  final stipendController = TextEditingController();
  final eligibilityController = TextEditingController();
  final skillsRequiredController = TextEditingController();
  final deadlineController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.internshipData != null) {
      companyController.text =
          widget.internshipData!['company'] ?? '';

      titleController.text =
          widget.internshipData!['title'] ?? '';
      final domain = widget.internshipData!['domain'];

      selectedDomain = [
        "Software Development",
        "AI/ML",
        "Embedded Systems",
        "Cyber Security",
        "Data Science",
        "IoT",
        "Electronics",
        "Mechanical",
        "Civil",
      ].contains(domain)
          ? domain
          : "Software Development";

      locationController.text =
          widget.internshipData!['location'] ?? '';

      final mode = widget.internshipData!['mode'];

      selectedMode = [
        "Online",
        "Offline",
        "Hybrid",
      ].contains(mode)
          ? mode
          : "Online";

      durationController.text =
          widget.internshipData!['duration'] ?? '';

      stipendController.text =
          widget.internshipData!['stipend'] ?? '';

      eligibilityController.text =
          widget.internshipData!['eligibility'] ?? '';

      skillsRequiredController.text =
          widget.internshipData!['skillsRequired'] ?? '';

      deadlineController.text =
          widget.internshipData!['deadline'] ?? '';

      descriptionController.text =
          widget.internshipData!['description'] ?? '';

      linkController.text =
          widget.internshipData!['link'] ?? '';
    }
  }

  Future<void> addInternship() async {
    if (companyController.text.trim().isEmpty ||
        titleController.text.trim().isEmpty ||
        deadlineController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields"),
        ),
      );
      return;
    }

    final Map<String, dynamic> internshipData = {

      'company': companyController.text.trim(),
      'title': titleController.text.trim(),
      'domain': selectedDomain,
      'location': locationController.text.trim(),
      'mode': selectedMode,
      'duration': durationController.text.trim(),
      'stipend': stipendController.text.trim(),
      'eligibility': eligibilityController.text.trim(),
      'skillsRequired': skillsRequiredController.text.trim(),
      'deadline': deadlineController.text.trim(),
      'description': descriptionController.text.trim(),
      'link': linkController.text.trim(),

    };

    if (widget.documentId == null) {
      internshipData['createdAt'] =
          FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('internships')
          .add(internshipData);


      await http.post(
        Uri.parse(
          "https://student-opportunity-hub-4hkx.onrender.com/sendNotification",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "title": "New Internship",
          "body":
          "${companyController.text.trim()} has posted ${titleController.text.trim()}.",
        }),
      );

    } else {

      await FirebaseFirestore.instance
          .collection('internships')
          .doc(widget.documentId)
          .update(internshipData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Internship updated successfully"),
        ),
      );

    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    companyController.dispose();
    titleController.dispose();
    locationController.dispose();
    durationController.dispose();
    stipendController.dispose();
    eligibilityController.dispose();
    skillsRequiredController.dispose();
    deadlineController.dispose();
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
              ? "Add Internship"
              : "Edit Internship",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(companyController, "Company Name"),
            buildTextField(titleController, "Internship Title"),
            DropdownButtonFormField<String>(
              value: selectedDomain,
              decoration: const InputDecoration(
                labelText: "Domain",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Software Development",
                  child: Text("Software Development"),
                ),
                DropdownMenuItem(
                  value: "AI/ML",
                  child: Text("AI/ML"),
                ),
                DropdownMenuItem(
                  value: "Embedded Systems",
                  child: Text("Embedded Systems"),
                ),
                DropdownMenuItem(
                  value: "Cyber Security",
                  child: Text("Cyber Security"),
                ),
                DropdownMenuItem(
                  value: "Data Science",
                  child: Text("Data Science"),
                ),
                DropdownMenuItem(
                  value: "IoT",
                  child: Text("IoT"),
                ),
                DropdownMenuItem(
                  value: "Electronics",
                  child: Text("Electronics"),
                ),
                DropdownMenuItem(
                  value: "Mechanical",
                  child: Text("Mechanical"),
                ),
                DropdownMenuItem(
                  value: "Civil",
                  child: Text("Civil"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedDomain = value!;
                });
              },
            ),
            buildTextField(locationController, "Location"),
            DropdownButtonFormField<String>(
              value: selectedMode,
              decoration: const InputDecoration(
                labelText: "Mode",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: "Online",
                  child: Text("Online"),
                ),
                DropdownMenuItem(
                  value: "Offline",
                  child: Text("Offline"),
                ),
                DropdownMenuItem(
                  value: "Hybrid",
                  child: Text("Hybrid"),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedMode = value!;
                });
              },
            ),
            buildTextField(durationController, "Duration"),
            buildTextField(stipendController, "Stipend"),
            buildTextField(
                eligibilityController, "Eligibility"),
            buildTextField(
                skillsRequiredController, "Skills Required"),
            buildTextField(deadlineController, "Application Deadline"),
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
                onPressed: addInternship,
                child: Text(
                  widget.documentId == null
                      ? "Save Internship"
                      : "Update Internship",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}