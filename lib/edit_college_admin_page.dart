import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCollegeAdminPage extends StatefulWidget {
  final String adminId;
  final Map<String, dynamic> adminData;

  const EditCollegeAdminPage({
    super.key,
    required this.adminId,
    required this.adminData,
  });

  @override
  State<EditCollegeAdminPage> createState() =>
      _EditCollegeAdminPageState();
}

class _EditCollegeAdminPageState
    extends State<EditCollegeAdminPage> {

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController collegeController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.adminData["name"] ?? "");

    emailController =
        TextEditingController(text: widget.adminData["email"] ?? "");

    collegeController =
        TextEditingController(text: widget.adminData["college"] ?? "");
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    collegeController.dispose();
    super.dispose();
  }

  Future<void> updateAdmin() async {
    await FirebaseFirestore.instance
        .collection("admins")
        .doc(widget.adminId)
        .update({
      "name": nameController.text.trim(),
      "college": collegeController.text.trim(),
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Admin updated successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit College Admin"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: emailController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: collegeController,
              decoration: const InputDecoration(
                labelText: "College",
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateAdmin,
                child: const Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}