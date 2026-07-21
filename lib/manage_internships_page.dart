import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_internship_page.dart';


class ManageInternshipsPage extends StatelessWidget {
  const ManageInternshipsPage({super.key});

  Future<void> deleteInternship(
      BuildContext context, String documentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Internship"),
        content: const Text(
          "Are you sure you want to delete this internship?",
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
          .collection("internships")
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Internship deleted successfully"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Internships"),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green, // Change button color
        foregroundColor: Colors.white, // Change icon color
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddInternshipPage(),
            ),
          );
        },
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("internships")
            .orderBy("createdAt", descending: true)
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
              child: Text("No internships found"),
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
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        data["title"] ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                          "Company : ${data["company"] ?? ""}"),

                      Text(
                          "Domain : ${data["domain"] ?? ""}"),

                      Text(
                          "Location : ${data["location"] ?? ""}"),

                      Text(
                          "Mode : ${data["mode"] ?? ""}"),

                      Text(
                          "Duration : ${data["duration"] ?? ""}"),

                      Text(
                          "Stipend : ${data["stipend"] ?? ""}"),

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
                                      AddInternshipPage(
                                        documentId: doc.id,
                                        internshipData: data,
                                      ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(width: 10),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9EB294),
                              foregroundColor: Colors.white,
                            ),
                            icon:
                            const Icon(Icons.delete),
                            label:
                            const Text("Delete"),
                            onPressed: () {
                              deleteInternship(
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