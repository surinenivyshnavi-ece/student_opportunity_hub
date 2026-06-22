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
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();

  Future<void> addInternship() async {

    await FirebaseFirestore.instance
        .collection('internships')
        .add({

      'company': companyController.text.trim(),

      'title': titleController.text.trim(),

      'deadline': deadlineController.text.trim(),

      'description': descriptionController.text.trim(),

      'link': linkController.text.trim(),

    });

    Navigator.pop(context);

  }

  @override
  void dispose() {
    companyController.dispose();
    titleController.dispose();
    deadlineController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    super.dispose();
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

            TextField(
              controller: companyController,
              decoration: const InputDecoration(
                labelText: "Company",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
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
                onPressed: addInternship,
                child: const Text("Save"),
              ),
            ),

          ],

        ),

      ),

    );

  }

}