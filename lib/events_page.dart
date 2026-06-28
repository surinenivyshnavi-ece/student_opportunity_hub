import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'opportunity_details_page.dart';
import 'add_event_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  final CollectionReference eventsRef =
  FirebaseFirestore.instance.collection('events');

  String searchText = "";
  String selectedType = "All";
  String selectedMode = "All";
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }
  Future<void> checkAdmin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final adminDoc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(user.uid)
        .get();

    if (adminDoc.exists) {
      setState(() {
        isAdmin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Events"),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddEventPage(),
                  ),
                );
              },
            ),
        ],
      ),

      body: Column(

        children: [

          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(

              decoration: const InputDecoration(
                hintText: "Search Events",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),

              onChanged: (value) {

                setState(() {

                  searchText = value.toLowerCase();

                });

              },

            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),

            child: Row(

              children: [

                Expanded(

                  child: DropdownButtonFormField<String>(

                    value: selectedType,

                    decoration: const InputDecoration(
                      labelText: "Event Type",
                      border: OutlineInputBorder(),
                    ),

                    items: const [

                      DropdownMenuItem(
                        value: "All",
                        child: Text("All"),
                      ),

                      DropdownMenuItem(
                        value: "Technical",
                        child: Text("Technical"),
                      ),

                      DropdownMenuItem(
                        value: "Cultural",
                        child: Text("Cultural"),
                      ),

                      DropdownMenuItem(
                        value: "Symposium",
                        child: Text("Symposium"),
                      ),

                      DropdownMenuItem(
                        value: "Conference",
                        child: Text("Conference"),
                      ),

                    ],

                    onChanged: (value) {

                      setState(() {

                        selectedType = value!;

                      });

                    },

                  ),

                ),

                const SizedBox(width: 10),

                Expanded(

                  child: DropdownButtonFormField<String>(

                    value: selectedMode,

                    decoration: const InputDecoration(
                      labelText: "Mode",
                      border: OutlineInputBorder(),
                    ),

                    items: const [

                      DropdownMenuItem(
                        value: "All",
                        child: Text("All"),
                      ),

                      DropdownMenuItem(
                        value: "Online",
                        child: Text("Online"),
                      ),

                      DropdownMenuItem(
                        value: "Offline",
                        child: Text("Offline"),
                      ),

                      DropdownMenuItem(
                        value: "Hybrid",
                        child: Text("Hybrid"),
                      ),

                    ],

                    onChanged: (value) {

                      setState(() {

                        selectedMode = value!;

                      });

                    },

                  ),

                ),

              ],

            ),

          ),

          const SizedBox(height: 10),

          Expanded(

            child: StreamBuilder<QuerySnapshot>(

              stream: eventsRef.snapshots(),

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
                    child: Text("No Events Available"),
                  );

                }

                final docs = snapshot.data!.docs.where((doc) {

                  final data =
                  doc.data() as Map<String, dynamic>;

                  final title =
                  (data['title'] ?? "")
                      .toString()
                      .toLowerCase();

                  final organizer =
                  (data['organizer'] ?? "")
                      .toString()
                      .toLowerCase();

                  final type =
                  (data['type'] ?? "")
                      .toString();

                  final mode =
                  (data['mode'] ?? "")
                      .toString();

                  return

                    (title.contains(searchText) ||
                        organizer.contains(searchText))

                        &&

                        (selectedType == "All" ||
                            type == selectedType)

                        &&

                        (selectedMode == "All" ||
                            mode == selectedMode);

                }).toList();

                if (docs.isEmpty) {

                  return const Center(
                    child: Text("No matching events"),
                  );

                }

                return ListView.builder(

                  itemCount: docs.length,

                  itemBuilder: (context, index) {

                    final data =
                    docs[index].data()
                    as Map<String, dynamic>;

                    return Card(

                      margin: const EdgeInsets.all(8),

                      child: ListTile(

                        leading:
                        const Icon(Icons.event),

                        title: Text(
                          data['title'] ?? "",
                        ),

                        subtitle: Text(
                          "Organizer: ${data['organizer'] ?? ""}\n"
                              "Type: ${data['type'] ?? ""}\n"
                              "Mode: ${data['mode'] ?? ""}\n"
                              "Date: ${data['date'] ?? ""}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            IconButton(
                              icon: const Icon(Icons.bookmark_add),
                              onPressed: () async {
                                final user = FirebaseAuth.instance.currentUser;

                                if (user == null) return;

                                await FirebaseFirestore.instance
                                    .collection('bookmarks')
                                    .doc(user.uid)
                                    .collection('saved')
                                    .doc(docs[index].id)
                                    .set({
                                  ...data,
                                  "type": "event",
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Event bookmarked"),
                                  ),
                                );
                              },
                            ),

                            if (isAdmin)
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {

                                  bool? confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Delete Event"),
                                        content: const Text(
                                          "Are you sure you want to delete this event?",
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

                                    await FirebaseFirestore.instance
                                        .collection('events')
                                        .doc(docs[index].id)
                                        .delete();

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Event deleted successfully"),
                                        ),
                                      );
                                    }

                                  }
                                },
                              ),

                          ],
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OpportunityDetailsPage(data: data),
                            ),
                          );
                        },

                      ),

                    );

                  },

                );

              },

            ),

          ),

        ],

      ),

    );

  }

}