import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'opportunity_details_page.dart';

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Workshops & Webinars"),
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