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
      backgroundColor: const Color(0xFF9EB294),

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "💬 Feedback",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            Card(
              color:  const Color(0xFFE9F5DB),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Your Name",
                    prefixIcon: Icon(Icons.person),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              color: const Color(0xFFE9F5DB),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: "Feedback Type",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.category),
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
              ),
            ),

            const SizedBox(height: 15),

            Card(
              color:  const Color(0xFFE9F5DB),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: feedbackController,
                  maxLines: 6,
                  decoration: const InputDecoration(
                    labelText: "Write your feedback",
                    prefixIcon: Icon(Icons.feedback),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: submitFeedback,
                icon: const Icon(Icons.send),
                label: const Text(
                  "Submit Feedback",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

          ],

        ),

      ),

    );

  }

}