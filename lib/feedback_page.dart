import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {

  final TextEditingController feedbackController =
  TextEditingController();

  final TextEditingController nameController =
  TextEditingController();

  String selectedType = "Suggestion";

  Future<void> submitFeedback() async {

    if (feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter your feedback"),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('feedback')
        .add({

      'name': nameController.text.trim(),

      'email': user?.email ?? "",

      'uid': user?.uid ?? "",

      'type': selectedType,

      'feedback': feedbackController.text.trim(),

      'submittedAt': FieldValue.serverTimestamp(),

    });

    feedbackController.clear();

    nameController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Feedback submitted successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Feedback"),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(

              controller: nameController,

              decoration: const InputDecoration(

                labelText: "Your Name",

                border: OutlineInputBorder(),

              ),

            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(

              value: selectedType,

              decoration: const InputDecoration(

                labelText: "Feedback Type",

                border: OutlineInputBorder(),

              ),

              items: const [

                DropdownMenuItem(
                  value: "Suggestion",
                  child: Text("Suggestion"),
                ),

                DropdownMenuItem(
                  value: "Bug Report",
                  child: Text("Bug Report"),
                ),

                DropdownMenuItem(
                  value: "Feature Request",
                  child: Text("Feature Request"),
                ),

                DropdownMenuItem(
                  value: "Other",
                  child: Text("Other"),
                ),

              ],

              onChanged: (value) {

                setState(() {

                  selectedType = value!;

                });

              },

            ),

            const SizedBox(height: 15),

            TextField(

              controller: feedbackController,

              maxLines: 6,

              decoration: const InputDecoration(

                labelText: "Write your feedback",

                border: OutlineInputBorder(),

              ),

            ),

            const SizedBox(height: 25),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: submitFeedback,

                child: const Text("Submit Feedback"),

              ),

            ),

          ],

        ),

      ),

    );

  }

}