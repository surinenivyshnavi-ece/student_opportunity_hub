import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_event_page.dart';

class ManageEventsPage extends StatelessWidget {
  const ManageEventsPage({super.key});

  Future<void> deleteEvent(
      BuildContext context, String documentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Event"),
        content: const Text(
          "Are you sure you want to delete this event?",
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
          .collection("events")
          .doc(documentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Event deleted successfully"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Events"),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEventPage(),
            ),
          );
        },
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("events")
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
              child: Text("No events found"),
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
                margin:
                const EdgeInsets.symmetric(vertical: 8),
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

                      Text("Type : ${data["eventType"] ?? ""}"),

                      Text("Venue : ${data["venue"] ?? ""}"),

                      Text("Date : ${data["date"] ?? ""}"),

                      Text("Time : ${data["time"] ?? ""}"),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.end,
                        children: [

                          ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text("Edit"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddEventPage(
                                        documentId: doc.id,
                                        eventData: data,
                                      ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(width: 10),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            icon: const Icon(Icons.delete),
                            label: const Text("Delete"),
                            onPressed: () {
                              deleteEvent(
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