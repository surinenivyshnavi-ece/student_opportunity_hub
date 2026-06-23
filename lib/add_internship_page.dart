import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddInternshipPage extends StatefulWidget {
  const AddInternshipPage({super.key});

  @override
  State<AddInternshipPage> createState() => _AddInternshipPageState();
}

class _AddInternshipPageState extends State<AddInternshipPage> {
  final companyController = TextEditingController();
  final titleController = TextEditingController();
  final domainController = TextEditingController();
  final locationController = TextEditingController();
  final modeController = TextEditingController();
  final durationController = TextEditingController();
  final stipendController = TextEditingController();
  final eligibilityController = TextEditingController();
  final skillsRequiredController = TextEditingController();
  final deadlineController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  Future<void> addInternship() async {
    await FirebaseFirestore.instance.collection('internships').add({
      'company': companyController.text.trim(),
      'title': titleController.text.trim(),
      'domain': domainController.text.trim(),
      'location': locationController.text.trim(),
      'mode': modeController.text.trim(),
      'duration': durationController.text.trim(),
      'stipend': stipendController.text.trim(),
      'eligibility': eligibilityController.text.trim(),
      'skillsRequired': skillsRequiredController.text.trim(),
      'deadline': deadlineController.text.trim(),
      'description': descriptionController.text.trim(),
      'link': linkController.text.trim(),
      'createdAt': Timestamp.now(),
    });

    Navigator.pop(context);

  }

  @override
  void dispose() {
    companyController.dispose();
    titleController.dispose();
    domainController.dispose();
    locationController.dispose();
    modeController.dispose();
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
        title: const Text("Add Internship"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(companyController, "Company Name"),
            buildTextField(titleController, "Internship Title"),
            buildTextField(domainController, "Domain"),
            buildTextField(locationController, "Location"),
            buildTextField(modeController, "Mode (Online/Offline/Hybrid)"),
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
                child: const Text(
                  "Save Internship",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}