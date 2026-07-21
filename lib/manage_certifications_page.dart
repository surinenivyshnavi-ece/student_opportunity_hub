import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_certification_page.dart';


class ManageCertificationsPage extends StatelessWidget {
  const ManageCertificationsPage({super.key});

  Future<void> deleteCertification(
      BuildContext context, String documentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Certification"),
        content: const Text(
          "Are you sure you want to delete this certification?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection("certifications")
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Certification deleted successfully",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Certifications"),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green, // Change button color
        foregroundColor: Colors.white, // Change icon color
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddCertificationPage(),
            ),
          );
        },
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("certifications")
            .orderBy(
          "createdAt",
          descending: true,
        )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No certifications found",
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data =
              doc.data() as Map<String, dynamic>;

              return Card(
                color: const Color(0xFFE9F5DB), // Your desired card color
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                child: Padding(
                  padding:
                  const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        data["title"] ?? "",
                        style:
                        const TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                          "Provider : ${data["provider"] ?? ""}"),

                      Text(
                          "Duration : ${data["duration"] ?? ""}"),

                      Text(
                          "Eligibility : ${data["eligibility"] ?? ""}"),

                      Text(
                          "Deadline : ${data["deadline"] ?? ""}"),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.end,
                        children: [

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9EB294),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddCertificationPage(
                                        documentId:
                                        doc.id,
                                        certificationData:
                                        data,
                                      ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9EB294),
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(
                              Icons.delete,
                            ),
                            label:
                            const Text(
                              "Delete",
                            ),
                            onPressed: () {
                              deleteCertification(
                                context,
                                doc.id,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}