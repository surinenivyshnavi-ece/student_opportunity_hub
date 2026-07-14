import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddEventPage extends StatefulWidget {
  final String? documentId;
  final Map<String, dynamic>? eventData;

  const AddEventPage({
    super.key,
    this.documentId,
    this.eventData,
  });

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {

  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final organizerController = TextEditingController();
  final dateController = TextEditingController();
  final venueController = TextEditingController();
  final deadlineController = TextEditingController();
  final feeController = TextEditingController();
  final descriptionController = TextEditingController();
  final registrationLinkController = TextEditingController();

  String selectedType = "Technical";
  String selectedMode = "Offline";
  @override
  void initState() {
    super.initState();

    if (widget.eventData != null) {
      titleController.text = widget.eventData!['title'] ?? '';
      organizerController.text = widget.eventData!['organizer'] ?? '';
      dateController.text = widget.eventData!['date'] ?? '';
      venueController.text = widget.eventData!['venue'] ?? '';
      deadlineController.text = widget.eventData!['deadline'] ?? '';
      feeController.text = widget.eventData!['eventFee'] ?? '';
      descriptionController.text = widget.eventData!['description'] ?? '';
      registrationLinkController.text =
          widget.eventData!['registrationLink'] ?? '';

      selectedType = widget.eventData!['type'] ?? "Technical";
      selectedMode = widget.eventData!['mode'] ?? "Offline";
    }
  }

  Future<void> addEvent() async {

    if (!_formKey.currentState!.validate()) return;

    Map<String, dynamic> eventData ={
      'title': titleController.text.trim(),
      'organizer': organizerController.text.trim(),
      'type': selectedType,
      'mode': selectedMode,
      'date': dateController.text.trim(),
      'venue': venueController.text.trim(),
      'deadline': deadlineController.text.trim(),
      'eventFee': feeController.text.trim(),
      'description': descriptionController.text.trim(),
      'registrationLink': registrationLinkController.text.trim(),
    };

    if (widget.documentId == null) {

      eventData['createdAt'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('events')
          .add(eventData);
      try {
        await http.post(
          Uri.parse(
            "https://student-opportunity-hub-4hkx.onrender.com/sendNotification",
          ),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "title": "📅 New Event",
            "body":
            "${organizerController.text.trim()} has announced ${titleController.text.trim()}.",
          }),
        );
      } catch (e) {
        debugPrint(e.toString());
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Event Added Successfully"),
        ),
      );

    } else {

      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.documentId)
          .update(eventData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Event Updated Successfully"),
        ),
      );
    }

    Navigator.pop(context,true);
  }

  Widget buildTextField(
      TextEditingController controller,
      String label,
      {int maxLines = 1}) {

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
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

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),

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
              ? "Add Event"
              : "Edit Event",
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Form(

          key: _formKey,

          child: Column(

            children: [

              buildTextField(titleController, "Event Title"),

              buildTextField(organizerController, "Organizer"),

              DropdownButtonFormField<String>(

                value: selectedType,

                decoration: const InputDecoration(
                  labelText: "Event Type",
                  border: OutlineInputBorder(),
                ),

                items: const [

                  DropdownMenuItem(
                    value: "Technical",
                    child: Text("Technical"),
                  ),

                  DropdownMenuItem(
                    value: "Cultural",
                    child: Text("Cultural"),
                  ),

                  DropdownMenuItem(
                    value: "Symposium",
                    child: Text("Symposium"),
                  ),

                  DropdownMenuItem(
                    value: "Conference",
                    child: Text("Conference"),
                  ),

                ],

                onChanged: (value) {

                  setState(() {

                    selectedType = value!;

                  });

                },

              ),

              const SizedBox(height: 15),

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

              const SizedBox(height: 15),

              buildTextField(dateController, "Event Date"),

              buildTextField(venueController, "Venue"),

              buildTextField(deadlineController, "Registration Deadline"),

              buildTextField(feeController, "Event Fee"),

              buildTextField(
                descriptionController,
                "Description",
                maxLines: 5,
              ),

              buildTextField(
                registrationLinkController,
                "Registration Link",
              ),

              const SizedBox(height: 25),

              SizedBox(

                width: double.infinity,

                child: ElevatedButton(

                  onPressed: addEvent,

                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),

                  child: Text(
                    widget.documentId == null
                        ? "Save Event"
                        : "Update Event",
                    style: const TextStyle(fontSize: 18),
                  ),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

  @override
  void dispose() {

    titleController.dispose();
    organizerController.dispose();
    dateController.dispose();
    venueController.dispose();
    deadlineController.dispose();
    feeController.dispose();
    descriptionController.dispose();
    registrationLinkController.dispose();

    super.dispose();
  }

}