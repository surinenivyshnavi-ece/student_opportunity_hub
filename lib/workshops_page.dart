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
      backgroundColor: const Color(0xFF9EB294),

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "🎓 Workshops & Webinars",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),

      body: Column(

        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(16,16,16,10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0,4),
                  ),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search Workshops",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value.toLowerCase();
                  });
                },
              ),
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
                      color:  const Color(0xFFE9F5DB),
                      elevation: 3,
                      shadowColor: Colors.black12,
                      margin: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OpportunityDetailsPage(data: data),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [

                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.orange.shade100,
                                    child: const Icon(
                                      Icons.school,
                                      color: Colors.orange,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Text(
                                      data['title'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              Text(
                                data['organizer'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [

                                  Chip(
                                    avatar: const Icon(Icons.category,size:18),
                                    label: Text(data['category'] ?? ''),
                                  ),

                                  Chip(
                                    avatar: const Icon(Icons.public,size:18),
                                    label: Text(data['mode'] ?? ''),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      data['date'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  IconButton(
                                    icon: const Icon(Icons.bookmark_border),
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
                                        bool? confirm = await showDialog<bool>(
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
                            ],
                          ),
                        ),
                      ),
                    );

                  },

                );

              },

            ),

          ),

        ],

      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddWorkshopPage(),
            ),
          );
        },
      )
          : null,

    );

  }

}