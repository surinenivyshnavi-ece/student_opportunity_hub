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
        }),
      );
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

                  DropdownMenuItem(
                    value: "Programming",
                    child: Text("Programming"),
                  ),

                  DropdownMenuItem(
                    value: "App Development",
                    child: Text("App Development"),
                  ),

                  DropdownMenuItem(
                    value: "AI/ML",
                    child: Text("AI/ML"),
                  ),

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