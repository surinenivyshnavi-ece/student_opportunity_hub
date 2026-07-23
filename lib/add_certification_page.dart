import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddCertificationPage extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? certificationData;

  const AddCertificationPage({
    super.key,
    this.documentId,
    this.certificationData,
  });

  @override
  State<AddCertificationPage> createState() =>
      _AddCertificationPageState();
}



class _AddCertificationPageState
    extends State<AddCertificationPage> {

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final platformController = TextEditingController();
  final durationController = TextEditingController();
  final eligibilityController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  String domain = "Programming";
  String mode = "Online";
  @override
  void initState() {
    super.initState();

    if (widget.certificationData != null) {
      titleController.text =
          widget.certificationData!['title'] ?? '';

      platformController.text =
          widget.certificationData!['platform'] ?? '';

      durationController.text =
          widget.certificationData!['duration'] ?? '';

      eligibilityController.text =
          widget.certificationData!['eligibility'] ?? '';

      descriptionController.text =
          widget.certificationData!['description'] ?? '';

      linkController.text =
          widget.certificationData!['link'] ?? '';

      domain =
          widget.certificationData!['domain'] ?? "Programming";

      mode =
          widget.certificationData!['mode'] ?? "Online";
    }
  }
  Future<void> addCertification() async {

    if (!_formKey.currentState!.validate()) return;

    final  Map<String,dynamic>certificationData = {
      "title": titleController.text.trim(),
      "platform": platformController.text.trim(),
      "domain": domain,
      "mode": mode,
      "duration": durationController.text.trim(),
      "eligibility": eligibilityController.text.trim(),
      "description": descriptionController.text.trim(),
      "link": linkController.text.trim(),
    };

    if (widget.documentId == null) {

      certificationData["createdAt"] =
          FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection("certifications")
          .add(certificationData);
     try {
       await http.post(
         Uri.parse(
           "https://student-opportunity-hub-4hkx.onrender.com/sendNotification",
         ),
         headers: {
           "Content-Type": "application/json",
         },
         body: jsonEncode({
           "title": "📜 New Certification",
           "body":
               "${platformController.text.trim()} has released ${titleController.text.trim()}.",
           "screen" :"certification",
         }),
       );
     } catch (e) {
       debugPrint(e.toString());
     }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Certification Added Successfully"),
        ),
      );

    } else {

      await FirebaseFirestore.instance
          .collection("certifications")
          .doc(widget.documentId)
          .update(certificationData);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Certification Updated Successfully"),
        ),
      );
    }

    Navigator.pop(context);
  }

  Widget buildField(
      String label,
      TextEditingController controller,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Enter $label";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    platformController.dispose();
    durationController.dispose();
    eligibilityController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.documentId == null
              ? "Add Certification"
              : "Edit Certification",
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              buildField("Course Title", titleController),

              buildField("Platform", platformController),

              DropdownButtonFormField<String>(

                value: domain,

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

                    domain = value!;

                  });

                },

              ),

              const SizedBox(height: 12),

              DropdownButtonFormField<String>(

                value: mode,

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

                ],

                onChanged: (value) {

                  setState(() {

                    mode = value!;

                  });

                },

              ),

              const SizedBox(height: 12),

              buildField("Duration", durationController),

              buildField("Eligibility", eligibilityController),

              buildField("Description", descriptionController),

              buildField("Registration Link", linkController),

              const SizedBox(height: 20),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: addCertification,

                  child: Text(
                    widget.documentId == null
                        ? "Add Certification"
                        : "Update Certification",
                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}