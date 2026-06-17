import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_team_formation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeamFormationPage extends StatefulWidget {
  const TeamFormationPage({super.key});

  @override
  State<TeamFormationPage> createState() =>
      _TeamFormationPageState();
}

class _TeamFormationPageState
    extends State<TeamFormationPage> {
  final CollectionReference teamRef =
  FirebaseFirestore.instance.collection(
    'team_formations',
  );

  String searchText = '';

  bool get isAdmin =>
      FirebaseAuth.instance.currentUser?.email ==
          "surinenivyshnavi2006@gmail.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Formation"),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const AddTeamFormationPage(),
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
                hintText: "Search Teams...",
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

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: teamRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      "Something went wrong",
                    ),
                  );
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                    CircularProgressIndicator(),
                  );
                }

                final docs =
                snapshot.data!.docs.where((doc) {
                  final data =
                  doc.data()
                  as Map<String, dynamic>;

                  final teamName =
                  (data['team name'] ?? '')
                      .toString()
                      .toLowerCase();

                  final skill =
                  (data['requiredSkill'] ?? '')
                      .toString()
                      .toLowerCase();

                  return teamName.contains(
                    searchText,
                  ) ||
                      skill.contains(searchText);
                }).toList();

                if (docs.isEmpty) {
                  return const Center(
                    child: Text("No teams found"),
                  );
                }

                return ListView.builder(
                  padding:
                  const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder:
                      (context, index) {
                    final data =
                    docs[index].data()
                    as Map<String,
                        dynamic>;

                    return Card(
                      child: ListTile(
                        leading:
                        const Icon(
                          Icons.groups,
                        ),

                        title: Text(
                          data['team name'] ??
                              '',
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              "Required Skill: ${data['requiredSkill'] ?? ''}",
                            ),

                            Text(
                              "Members Needed: ${data['membersNeeded'] ?? ''}",
                            ),

                            Text(
                              "Contact: ${data['contact'] ?? ''}",
                            ),
                          ],
                        ),

                        trailing: isAdmin
                            ? IconButton(
                          icon:
                          const Icon(
                            Icons
                                .delete,
                          ),
                          onPressed:
                              () async {
                            await teamRef
                                .doc(
                              docs[index]
                                  .id,
                            )
                                .delete();
                          },
                        )
                            : null,
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