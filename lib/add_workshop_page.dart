import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddWorkshopPage extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? workshopData;

  const AddWorkshopPage({
    super.key,
    this.documentId,
    this.workshopData,
  });

  @override
  State<AddWorkshopPage> createState() =>
      _AddWorkshopPageState();
}



class _AddWorkshopPageState extends State<AddWorkshopPage> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final organizerController = TextEditingController();
  final dateController = TextEditingController();
  final durationController = TextEditingController();
  final locationController = TextEditingController();
  final eligibilityController = TextEditingController();
  final registrationFeeController = TextEditingController();
  final deadlineController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  String category = "Workshop";
  String mode = "Offline";
  @override
  void initState() {
    super.initState();

    if (widget.workshopData != null) {
      titleController.text = widget.workshopData!['title'] ?? '';
      organizerController.text = widget.workshopData!['organizer'] ?? '';
      dateController.text = widget.workshopData!['date'] ?? '';
      durationController.text = widget.workshopData!['duration'] ?? '';
      locationController.text = widget.workshopData!['location'] ?? '';
      eligibilityController.text =
          widget.workshopData!['eligibility'] ?? '';
      registrationFeeController.text =
          widget.workshopData!['registrationFee'] ?? '';
      deadlineController.text =
          widget.workshopData!['deadline'] ?? '';
      descriptionController.text =
          widget.workshopData!['description'] ?? '';
      linkController.text =
          widget.workshopData!['link'] ?? '';

      category =
          widget.workshopData!['category'] ?? "Workshop";
      mode =
          widget.workshopData!['mode'] ?? "Offline";
    }
  }

  Future<void> addWorkshop() async {

    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> workshopData = {
      "title": titleController.text.trim(),
      "organizer": organizerController.text.trim(),
      "category": category,
      "mode": mode,
      "date": dateController.text.trim(),
      "duration": durationController.text.trim(),
      "location": locationController.text.trim(),
      "eligibility": eligibilityController.text.trim(),
      "registrationFee": registrationFeeController.text.trim(),
      "deadline": deadlineController.text.trim(),
      "description": descriptionController.text.trim(),
      "link": linkController.text.trim(),
    };

    if (widget.documentId == null) {

      workshopData["createdAt"] =
          FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection("workshops")
          .add(workshopData);
      try {
        final response = await http.post(
          Uri.parse(
            "https://student-opportunity-hub-4hkx.onrender.com/sendNotification",
          ),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "title": "🎓 New Workshop",
            "body":
            "${organizerController.text.trim()} is conducting ${titleController.text.trim()}.",
            "screen": "workshop",
          }),
        );

        print("Status Code: ${response.statusCode}");
        print("Response: ${response.body}");

      } catch (e) {
        print("Notification Error: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Workshop Added Successfully"),
        ),
      );

    } else {

      await FirebaseFirestore.instance
          .collection("workshops")
          .doc(widget.documentId)
          .update(workshopData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Workshop Updated Successfully"),
        ),
      );
    }

    Navigator.pop(context);
  }

  Widget buildTextField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
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
    organizerController.dispose();
    dateController.dispose();
    durationController.dispose();
    locationController.dispose();
    eligibilityController.dispose();
    registrationFeeController.dispose();
    deadlineController.dispose();
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
              ? "Add Workshop/Webinar"
              : "Edit Workshop/Webinar",
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              buildTextField("Title", titleController),

              buildTextField("Organizer", organizerController),

              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: "Workshop",
                    child: Text("Workshop"),
                  ),
                  DropdownMenuItem(
                    value: "Webinar",
                    child: Text("Webinar"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    category = value!;
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
                  DropdownMenuItem(
                    value: "Hybrid",
                    child: Text("Hybrid"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    mode = value!;
                  });
                },
              ),

              const SizedBox(height: 12),

              buildTextField("Date", dateController),

              buildTextField("Duration", durationController),

              buildTextField("Location", locationController),

              buildTextField("Eligibility", eligibilityController),

              buildTextField("Registration Fee", registrationFeeController),

              buildTextField("Registration Deadline", deadlineController),

              buildTextField(
                "Description",
                descriptionController,
                maxLines: 5,
              ),

              buildTextField("Registration Link", linkController),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addWorkshop,
                  child: Text(
                    widget.documentId == null
                        ? "Add Workshop"
                        : "Update Workshop",
                    style: const TextStyle(fontSize: 16),
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