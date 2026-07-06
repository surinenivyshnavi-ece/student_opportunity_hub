import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'opportunity_details_page.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Please login"),
        ),
      );
    }


    return Scaffold(
      backgroundColor: const Color(0xFF9EB294),

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "🔖 Bookmarks",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('bookmarks')
            .doc(user.uid)
            .collection('saved')
            .snapshots(),


        builder: (context, snapshot) {


          if(snapshot.connectionState ==
              ConnectionState.waiting){

            return const Center(
              child: CircularProgressIndicator(),
            );

          }


          if(!snapshot.hasData ||
              snapshot.data!.docs.isEmpty){

            return const Center(
              child: Text(
                "No bookmarks saved",
              ),
            );

          }


          final docs = snapshot.data!.docs;


          return ListView.builder(

            padding: const EdgeInsets.all(12),

            itemCount: docs.length,


            itemBuilder: (context,index){


              final data =
              docs[index].data()
              as Map<String,dynamic>;


              return Card(
                color: const Color(0xFFE9F5DB),
                elevation: 2,
                shadowColor: Colors.black12,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OpportunityDetailsPage(
                          data: data,
                        ),
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
                              backgroundColor: Colors.amber.shade100,
                              child: Icon(
                                Icons.bookmark,
                                color: Colors.amber.shade800,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                data['title'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black38,
                              ),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('bookmarks')
                                    .doc(user.uid)
                                    .collection('saved')
                                    .doc(docs[index].id)
                                    .delete();
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          data['type']?.toString().toUpperCase() ?? "",
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        if (data['type'] == 'internship')
                          Wrap(
                            spacing: 8,
                            children: [
                              Chip(label: Text(data['company'] ?? "")),
                              Chip(label: Text(data['deadline'] ?? "")),
                            ],
                          ),

                        if (data['type'] == 'hackathon')
                          Wrap(
                            spacing: 8,
                            children: [
                              Chip(label: Text(data['organizer'] ?? "")),
                              Chip(label: Text(data['prize'] ?? "")),
                            ],
                          ),

                        if (data['type'] == 'team')
                          Wrap(
                            spacing: 8,
                            children: [
                              Chip(label: Text(data['requiredSkill'] ?? "")),
                              Chip(label: Text(data['membersNeeded'] ?? "")),
                            ],
                          ),

                        if (data['type'] == 'certification')
                          Wrap(
                            spacing: 8,
                            children: [
                              Chip(label: Text(data['platform'] ?? "")),
                              Chip(label: Text(data['duration'] ?? "")),
                            ],
                          ),

                        if (data['type'] == 'event')
                          Wrap(
                            spacing: 8,
                            children: [
                              Chip(label: Text(data['organizer'] ?? "")),
                              Chip(label: Text(data['date'] ?? "")),
                            ],
                          ),

                        if (data['type'] == 'workshop')
                          Wrap(
                            spacing: 8,
                            children: [
                              Chip(label: Text(data['organizer'] ?? "")),
                              Chip(label: Text(data['date'] ?? "")),
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

    );

  }
}