import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminRequestFormPage extends StatefulWidget {
  const AdminRequestFormPage({super.key});

  @override
  State<AdminRequestFormPage> createState() => _AdminRequestFormPageState();
}

class _AdminRequestFormPageState extends State<AdminRequestFormPage> {
  String? selectedCollege;
  String? selectedBranch;

  final List<String> branches = [
    "CSE",
    "ECE",
    "EEE",
    "MECH",
    "CIVIL",
    "IT",
    "AIML",
    "CSM",
  ];

  bool loading = false;

  Future<void> submitRequest() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    if (selectedCollege == null || selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select college and branch"),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    await FirebaseFirestore.instance
        .collection("admin_requests")
        .doc(user.uid)
        .set({
      "uid": user.uid,
      "name": user.displayName ?? "",
      "email": user.email ?? "",
      "college": selectedCollege,
      "branch": selectedBranch,
      "status": "pending",
      "requestedAt": Timestamp.now(),
    });

    setState(() {
      loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Admin request submitted successfully"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Request College Admin Access"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: "Name",
                hintText: user?.displayName ?? "",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: user?.email ?? "",
              ),
            ),
            const SizedBox(height: 15),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("colleges")
                  .where("active", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text("No colleges found");
                }

                final colleges = snapshot.data!.docs;

                return DropdownButtonFormField<String>(
                  value: selectedCollege,
                  decoration: const InputDecoration(
                    labelText: "College",
                  ),
                  items: colleges.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    return DropdownMenuItem<String>(
                      value: data["shortName"],
                      child: Text(data["shortName"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCollege = value;
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedBranch,
              decoration: const InputDecoration(
                labelText: "Branch",
              ),
              items: branches.map((branch) {
                return DropdownMenuItem(
                  value: branch,
                  child: Text(branch),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedBranch = value;
                });
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : submitRequest,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Submit Request"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}