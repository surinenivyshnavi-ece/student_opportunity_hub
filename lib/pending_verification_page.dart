import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'complete_profile_page.dart';


class PendingVerificationPage extends StatefulWidget {
  const PendingVerificationPage({super.key});

  @override
  State<PendingVerificationPage> createState() =>
      _PendingVerificationPageState();
}

class _PendingVerificationPageState
    extends State<PendingVerificationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification Pending"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final status = data["status"] ?? "pending";
          final reason = data["rejectionReason"] ?? "";

          if (status == "rejected") {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Icon(
                      Icons.cancel,
                      size: 80,
                      color: Colors.red,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Verification Rejected",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      reason,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CompleteProfilePage(),
                          ),
                        );
                      },
                      child: const Text("Resubmit Profile"),
                    ),

                  ],
                ),
              ),
            );
          }

          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.hourglass_top,
                    size: 80,
                    color: Colors.orange,
                  ),

                  SizedBox(height: 20),

                  Text(
                    "Your profile has been submitted successfully.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Your college administrator will verify your details. You will be able to access the app after approval.",
                    textAlign: TextAlign.center,
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}