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
  final locationController = TextEditingController();
  final teamSizeController = TextEditingController();
  final eligibilityController = TextEditingController();
  final registrationFeeController = TextEditingController();
  final deadlineController = TextEditingController();
  final prizeController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  String selectedDomain = "AI/ML";
  String selectedMode = "Online";

  @override
  void initState() {
    super.initState();

    if (widget.hackathonData != null) {
      titleController.text =
          widget.hackathonData!['title'] ?? '';

      organizerController.text =
          widget.hackathonData!['organizer'] ?? '';


      locationController.text =
          widget.hackathonData!['location'] ?? '';

      selectedDomain =
          widget.hackathonData!['domain'] ?? "AI/ML";

      selectedMode =
          widget.hackathonData!['mode'] ?? "Online";



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
      'location': locationController.text.trim(),
      'domain': selectedDomain,
      'mode': selectedMode,

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
      try {
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
      } catch (e) {
        debugPrint(e.toString());
      }
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

    locationController.dispose();

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
            DropdownButtonFormField<String>(
              value: selectedDomain,
              decoration: const InputDecoration(
                labelText: "Domain",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "All", child: Text("All")),
                DropdownMenuItem(value: "AI/ML", child: Text("AI/ML")),
                DropdownMenuItem(value: "Data Science", child: Text("Data Science")),
                DropdownMenuItem(value: "App Development", child: Text("App Development")),
                DropdownMenuItem(value: "Web Development", child: Text("Web Development")),
                DropdownMenuItem(value: "Embedded Systems", child: Text("Embedded Systems")),
                DropdownMenuItem(value: "IoT", child: Text("Internet of Things (IoT)")),
                DropdownMenuItem(value: "Cyber Security", child: Text("Cyber Security")),
                DropdownMenuItem(value: "Cloud Computing", child: Text("Cloud Computing")),
                DropdownMenuItem(value: "DevOps", child: Text("DevOps")),
                DropdownMenuItem(value: "Blockchain", child: Text("Blockchain")),
                DropdownMenuItem(value: "Robotics", child: Text("Robotics")),
                DropdownMenuItem(value: "AR/VR", child: Text("AR/VR")),
                DropdownMenuItem(value: "Game Development", child: Text("Game Development")),
                DropdownMenuItem(value: "Computer Vision", child: Text("Computer Vision")),
                DropdownMenuItem(value: "NLP", child: Text("Natural Language Processing")),
                DropdownMenuItem(value: "Electronics", child: Text("Electronics")),
                DropdownMenuItem(value: "VLSI", child: Text("VLSI")),
                DropdownMenuItem(value: "Communication Systems", child: Text("Communication Systems")),
                DropdownMenuItem(value: "Signal Processing", child: Text("Signal Processing")),
                DropdownMenuItem(value: "Control Systems", child: Text("Control Systems")),
                DropdownMenuItem(value: "Automation", child: Text("Automation")),
                DropdownMenuItem(value: "Electrical", child: Text("Electrical Engineering")),
                DropdownMenuItem(value: "Mechanical", child: Text("Mechanical Engineering")),
                DropdownMenuItem(value: "Civil", child: Text("Civil Engineering")),
                DropdownMenuItem(value: "Chemical", child: Text("Chemical Engineering")),
                DropdownMenuItem(value: "Biomedical", child: Text("Biomedical Engineering")),
                DropdownMenuItem(value: "Aerospace", child: Text("Aerospace Engineering")),
                DropdownMenuItem(value: "Automobile", child: Text("Automobile Engineering")),
                DropdownMenuItem(value: "3D Printing", child: Text("3D Printing")),
                DropdownMenuItem(value: "Renewable Energy", child: Text("Renewable Energy")),
                DropdownMenuItem(value: "Smart Agriculture", child: Text("Smart Agriculture")),
                DropdownMenuItem(value: "FinTech", child: Text("FinTech")),
                DropdownMenuItem(value: "EdTech", child: Text("EdTech")),
                DropdownMenuItem(value: "HealthTech", child: Text("HealthTech")),
                DropdownMenuItem(value: "UI/UX Design", child: Text("UI/UX Design")),
                DropdownMenuItem(value: "Product Design", child: Text("Product Design")),
                DropdownMenuItem(value: "Digital Marketing", child: Text("Digital Marketing")),
                DropdownMenuItem(value: "Entrepreneurship", child: Text("Entrepreneurship")),
                DropdownMenuItem(value: "Open Innovation", child: Text("Open Innovation")),
                DropdownMenuItem(value: "Research", child: Text("Research")),
                DropdownMenuItem(value: "General", child: Text("General")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedDomain = value!;
                });
              },
            ),
            buildTextField(
              locationController,
              "Location",
            ),
            DropdownButtonFormField<String>(
              value: selectedMode,
              decoration: const InputDecoration(
                labelText: "Mode",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "Online", child: Text("Online")),
                DropdownMenuItem(value: "Offline", child: Text("Offline")),
                DropdownMenuItem(value: "Hybrid", child: Text("Hybrid")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedMode = value!;
                });
              },
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