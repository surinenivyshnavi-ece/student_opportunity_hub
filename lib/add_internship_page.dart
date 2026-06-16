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
  final deadlineController = TextEditingController();
  final linkController = TextEditingController();

  Future<void> addInternship() async {
    await FirebaseFirestore.instance.collection('internships').add({
      'company': companyController.text,
      'title': titleController.text,
      'deadline': deadlineController.text,
      'link': linkController.text,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Internship")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: companyController,
              decoration: const InputDecoration(labelText: "Company"),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: deadlineController,
              decoration: const InputDecoration(labelText: "Deadline"),
            ),
            TextField(
              controller: linkController,
              decoration: const InputDecoration(labelText: "Link"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addInternship,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}