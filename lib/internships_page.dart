import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_internship_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InternshipsPage extends StatelessWidget {

  InternshipsPage({super.key});


  final CollectionReference internshipsRef =
  FirebaseFirestore.instance.collection('internships');
  bool get isAdmin =>
      FirebaseAuth.instance.currentUser?.email ==
          "surinenivyshnavi2006@gmail.com";


  Future<void> openLink(String link) async {

    final Uri url = Uri.parse(link);

    if (await canLaunchUrl(url)) {

      await launchUrl(url);

    }

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Internships"),

        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddInternshipPage(),
                  ),
                );
              },
            ),
        ],

      ),


      body: StreamBuilder<QuerySnapshot>(

        stream: internshipsRef.snapshots(),

        builder: (context, snapshot) {


          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );

          }


          final docs = snapshot.data!.docs;


          if (docs.isEmpty) {

            return const Center(
              child: Text("No internships available"),
            );

          }


          return ListView.builder(

            padding: const EdgeInsets.all(12),

            itemCount: docs.length,


            itemBuilder: (context,index) {


              final data =
              docs[index].data()
              as Map<String,dynamic>;


              return Card(

                child: ListTile(

                  leading: const Icon(Icons.work),


                  title: Text(
                    data['company'] ?? '',
                  ),


                  subtitle: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [


                      Text(
                        "Title: ${data['title'] ?? ''}",
                      ),


                      Text(
                        "Deadline: ${data['deadline'] ?? ''}",
                      ),


                      TextButton(

                        onPressed: () {

                          openLink(
                            data['link'] ?? '',
                          );

                        },

                        child: const Text(
                          "Open Application Link",
                        ),

                      ),

                    ],

                  ),


                  trailing: isAdmin
                      ? IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await internshipsRef
                          .doc(docs[index].id)
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

    );

  }

}