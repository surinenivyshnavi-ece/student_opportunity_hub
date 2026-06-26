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

      appBar: AppBar(
        title: const Text("Bookmarks"),
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

                child: ListTile(

                  leading:
                  const Icon(Icons.bookmark),


                  title: Text(
                    data['title'] ?? '',
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


                  subtitle: Text(
                    data['type'] == 'internship'
                        ? "Company: ${data['company'] ?? ''}\nDeadline: ${data['deadline'] ?? ''}"
                        : "Organizer: ${data['organizer'] ?? ''}\nDeadline: ${data['deadline'] ?? ''}",
                  ),


                  trailing: IconButton(

                    icon:
                    const Icon(Icons.delete),


                    onPressed: () async {

                      await FirebaseFirestore.instance
                          .collection('bookmarks')
                          .doc(user.uid)
                          .collection('saved')
                          .doc(docs[index].id)
                          .delete();

                    },

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