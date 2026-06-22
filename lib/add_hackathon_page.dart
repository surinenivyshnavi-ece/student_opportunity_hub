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
  final deadlineController = TextEditingController();
  final prizeController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  Future<void> addHackathon() async {

    await FirebaseFirestore.instance
        .collection('hackathons')
        .add({

      'title': titleController.text.trim(),

      'organizer': organizerController.text.trim(),

      'deadline': deadlineController.text.trim(),

      'prize': prizeController.text.trim(),

      'description': descriptionController.text.trim(),

      'link': linkController.text.trim(),

    });

    Navigator.pop(context);

  }

  @override
  void dispose() {
    titleController.dispose();
    organizerController.dispose();
    deadlineController.dispose();
    prizeController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
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

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Hackathon Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: organizerController,
              decoration: const InputDecoration(
                labelText: "Organizer",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(
                labelText: "Deadline",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: prizeController,
              decoration: const InputDecoration(
                labelText: "Prize Money",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: linkController,
              decoration: const InputDecoration(
                labelText: "Application Link",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addHackathon,
                child: const Text("Save"),
              ),
            ),

          ],

        ),

      ),

    );

  }

}