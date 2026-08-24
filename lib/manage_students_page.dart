import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageStudentsPage extends StatelessWidget {
  const ManageStudentsPage({super.key});

  Future<void> toggleStatus(
      DocumentSnapshot student,
      ) async {
    final data = student.data() as Map<String, dynamic>;

    final currentStatus = data["status"] ?? "active";

    await student.reference.update({
      "status":
      currentStatus == "active" ? "inactive" : "active",
    });
  }

  Future<void> deleteStudent(
      BuildContext context,
      DocumentSnapshot student,
      ) async {
    final data = student.data() as Map<String, dynamic>;

    final name = data["name"] ?? "this student";

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Student"),
          content: Text(
            "Are you sure you want to delete $name?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await student.reference.delete();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Student deleted successfully"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Students"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No Students Found",
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          final students = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: students.length,

            itemBuilder: (context, index) {
              final student = students[index];

              final data =
              student.data() as Map<String, dynamic>;

              final name = data["name"] ?? "No Name";
              final email = data["email"] ?? "No Email";
              final college =
                  data["college"] ?? "Not Provided";
              final branch =
                  data["branch"] ?? "Not Provided";
              final status =
                  data["status"] ?? "active";

              return Card(
                margin:
                const EdgeInsets.only(bottom: 12),

                child: Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            child: Icon(Icons.person),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              name.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text("Email: $email"),

                      const SizedBox(height: 5),

                      Text("College: $college"),

                      const SizedBox(height: 5),

                      Text("Branch: $branch"),

                      const SizedBox(height: 5),

                      Text(
                        "Status: $status",
                        style: TextStyle(
                          fontWeight:
                          FontWeight.bold,
                          color:
                          status == "active"
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.end,

                        children: [
                          ElevatedButton(
                            onPressed: () {
                              toggleStatus(student);
                            },
                            child: Text(
                              status == "active"
                                  ? "Deactivate"
                                  : "Activate",
                            ),
                          ),

                          const SizedBox(width: 10),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              deleteStudent(
                                context,
                                student,
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