import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'opportunity_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_workshop_page.dart';

class WorkshopsPage extends StatefulWidget {
  const WorkshopsPage({super.key});

  @override
  State<WorkshopsPage> createState() => _WorkshopsPageState();
}

class _WorkshopsPageState extends State<WorkshopsPage> {

  final CollectionReference workshopsRef =
  FirebaseFirestore.instance.collection('workshops');

  String searchText = "";
  String selectedMode = "All";
  String selectedCategory = "All";
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
        title: const Text("Workshops & Webinars"),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddWorkshopPage(),
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
                hintText: "Search Workshops",
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

                    value: selectedCategory,

                    decoration: const InputDecoration(
                      labelText: "Category",
                      border: OutlineInputBorder(),
                    ),

                    items: const [

                      DropdownMenuItem(
                        value: "All",
                        child: Text("All"),
                      ),

                      DropdownMenuItem(
                        value: "Workshop",
                        child: Text("Workshop"),
                      ),

                      DropdownMenuItem(
                        value: "Webinar",
                        child: Text("Webinar"),
                      ),

                    ],

                    onChanged: (value) {

                      setState(() {

                        selectedCategory = value!;

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

              stream: workshopsRef.snapshots(),

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
                    child: Text("No Workshops Available"),
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

                  final mode =
                  (data['mode'] ?? "")
                      .toString();

                  final category =
                  (data['category'] ?? "")
                      .toString();

                  return

                    (title.contains(searchText) ||
                        organizer.contains(searchText))

                        &&

                        (selectedMode == "All" ||
                            mode == selectedMode)

                        &&

                        (selectedCategory == "All" ||
                            category == selectedCategory);

                }).toList();

                if (docs.isEmpty) {

                  return const Center(
                    child: Text("No matching workshops"),
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

                        leading: const Icon(Icons.school),

                        title: Text(data['title'] ?? ""),

                        subtitle: Text(
                          "Organizer: ${data['organizer'] ?? ""}\n"
                              "Category: ${data['category'] ?? ""}\n"
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
                                  "type": "workshop",
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Workshop bookmarked"),
                                  ),
                                );
                              },
                            ),
                            if (isAdmin)
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddWorkshopPage(
                                        documentId: docs[index].id,
                                        workshopData: data,
                                      ),
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
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Delete Workshop"),
                                      content: const Text(
                                        "Are you sure you want to delete this workshop?",
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
                                    ),
                                  );

                                  if (confirm == true) {
                                    await FirebaseFirestore.instance
                                        .collection('workshops')
                                        .doc(docs[index].id)
                                        .delete();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Workshop deleted"),
                                      ),
                                    );
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
                                  OpportunityDetailsPage(
                                    data: data,
                                  ),
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