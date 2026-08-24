import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageContentPage extends StatelessWidget {
  const ManageContentPage({super.key});

  final List<Map<String, dynamic>> contentTypes = const [
    {
      "title": "Internships",
      "collection": "internships",
      "icon": Icons.work,
    },
    {
      "title": "Hackathons",
      "collection": "hackathons",
      "icon": Icons.emoji_events,
    },
    {
      "title": "Events",
      "collection": "events",
      "icon": Icons.event,
    },
    {
      "title": "Workshops",
      "collection": "workshops",
      "icon": Icons.school,
    },
    {
      "title": "Certifications",
      "collection": "certifications",
      "icon": Icons.workspace_premium,
    },
    {
      "title": "Team Formation",
      "collection": "team_formations",
      "icon": Icons.groups,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Content"),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: contentTypes.length,

        itemBuilder: (context, index) {
          final item = contentTypes[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),

            child: ListTile(
              contentPadding: const EdgeInsets.all(12),

              leading: CircleAvatar(
                child: Icon(
                  item["icon"],
                ),
              ),

              title: Text(
                item["title"],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(item["collection"])
                    .snapshots(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  }

                  if (snapshot.hasError) {
                    return const Text(
                      "Error loading",
                      style: TextStyle(color: Colors.red),
                    );
                  }

                  return Text(
                    "${snapshot.data?.docs.length ?? 0} items",
                  );
                },
              ),

              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ContentListPage(
                          title: item["title"],
                          collection: item["collection"],
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


/// Page showing the actual content inside
/// a selected collection.
class ContentListPage extends StatelessWidget {
  final String title;
  final String collection;

  const ContentListPage({
    super.key,
    required this.title,
    required this.collection,
  });

  Future<void> deleteContent(
      BuildContext context,
      DocumentSnapshot document,
      ) async {
    final data =
    document.data() as Map<String, dynamic>;

    final confirm = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Content"),

          content: Text(
            "Are you sure you want to delete "
                "${data["title"] ?? "this item"}?",
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

    if (confirm == true) {
      await document.reference.delete();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Content deleted successfully",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(collection)
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
                "No Content Found",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),

            itemCount: documents.length,

            itemBuilder: (context, index) {
              final document = documents[index];

              final data =
              document.data()
              as Map<String, dynamic>;

              final itemTitle =
                  data["title"] ??
                      data["name"] ??
                      "Untitled";

              final description =
                  data["description"] ?? "";

              final organizer =
                  data["organizer"] ?? "";

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 12,
                ),

                child: Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Text(
                        itemTitle.toString(),

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      if (description
                          .toString()
                          .isNotEmpty) ...[
                        const SizedBox(height: 8),

                        Text(
                          description.toString(),
                        ),
                      ],

                      if (organizer
                          .toString()
                          .isNotEmpty) ...[
                        const SizedBox(height: 8),

                        Text(
                          "Organizer: "
                              "$organizer",
                        ),
                      ],

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.end,

                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                            ),

                            onPressed: () {
                              showEditDialog(
                                context,
                                document,
                                data,
                              );
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),

                            onPressed: () {
                              deleteContent(
                                context,
                                document,
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

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () {
          showAddDialog(context);
        },
      ),
    );
  }

  void showAddDialog(BuildContext context) {
    final titleController =
    TextEditingController();

    final descriptionController =
    TextEditingController();

    final organizerController =
    TextEditingController();

    final linkController =
    TextEditingController();

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(
            "Add $title",
          ),

          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration:
                  const InputDecoration(
                    labelText: "Title",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller:
                  descriptionController,
                  maxLines: 3,
                  decoration:
                  const InputDecoration(
                    labelText: "Description",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller:
                  organizerController,
                  decoration:
                  const InputDecoration(
                    labelText: "Organizer",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: linkController,
                  decoration:
                  const InputDecoration(
                    labelText: "Link",
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                if (titleController.text
                    .trim()
                    .isEmpty) {
                  return;
                }

                await FirebaseFirestore.instance
                    .collection(collection)
                    .add({
                  "title":
                  titleController.text.trim(),

                  "description":
                  descriptionController
                      .text
                      .trim(),

                  "organizer":
                  organizerController
                      .text
                      .trim(),

                  "link":
                  linkController.text.trim(),

                  "createdAt":
                  Timestamp.now(),
                });

                if (!context.mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Content added successfully",
                    ),
                  ),
                );
              },

              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(
      BuildContext context,
      DocumentSnapshot document,
      Map<String, dynamic> data,
      ) {
    final titleController =
    TextEditingController(
      text: data["title"] ??
          data["name"] ??
          "",
    );

    final descriptionController =
    TextEditingController(
      text: data["description"] ?? "",
    );

    final organizerController =
    TextEditingController(
      text: data["organizer"] ?? "",
    );

    final linkController =
    TextEditingController(
      text: data["link"] ?? "",
    );

    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: Text(
            "Edit $title",
          ),

          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration:
                  const InputDecoration(
                    labelText: "Title",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller:
                  descriptionController,
                  maxLines: 3,
                  decoration:
                  const InputDecoration(
                    labelText: "Description",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller:
                  organizerController,
                  decoration:
                  const InputDecoration(
                    labelText: "Organizer",
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: linkController,
                  decoration:
                  const InputDecoration(
                    labelText: "Link",
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {
                await document.reference.update({
                  "title":
                  titleController.text.trim(),

                  "description":
                  descriptionController
                      .text
                      .trim(),

                  "organizer":
                  organizerController
                      .text
                      .trim(),

                  "link":
                  linkController.text.trim(),
                });

                if (!context.mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Content updated successfully",
                    ),
                  ),
                );
              },

              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }
}