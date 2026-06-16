import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddHackathonPage extends StatefulWidget {
  const AddHackathonPage({super.key});

  @override
  State<AddHackathonPage> createState() => _AddHackathonPageState();
}

class _AddHackathonPageState extends State<AddHackathonPage> {
  final titleController = TextEditingController();
  final organizerController = TextEditingController();
  final deadlineController = TextEditingController();
  final prizeController = TextEditingController();

  Future<void> addHackathon() async {
    await FirebaseFirestore.instance.collection('hackathons').add({
      'title': titleController.text,
      'organizer': organizerController.text,
      'deadline': deadlineController.text,
      'prize': prizeController.text,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Hackathon"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Hackathon Title",
              ),
            ),
            TextField(
              controller: organizerController,
              decoration: const InputDecoration(
                labelText: "Organizer",
              ),
            ),
            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(
                labelText: "Deadline",
              ),
            ),
            TextField(
              controller: prizeController,
              decoration: const InputDecoration(
                labelText: "Prize",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addHackathon,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}