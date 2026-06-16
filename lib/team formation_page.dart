import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_team_formation_page.dart';

class TeamFormationPage extends StatelessWidget {
  TeamFormationPage({super.key});

  final CollectionReference teamRef =
  FirebaseFirestore.instance.collection('team_formations');


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Team Formation"),

        actions: [

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


      body: StreamBuilder<QuerySnapshot>(

        stream: teamRef.snapshots(),

        builder: (context, snapshot) {


          if (snapshot.hasError) {

            return const Center(

              child: Text("Something went wrong"),

            );

          }


          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(

              child: CircularProgressIndicator(),

            );

          }


          final docs = snapshot.data!.docs;


          if (docs.isEmpty) {

            return const Center(

              child: Text("No teams available"),

            );

          }



          return ListView.builder(

            padding: const EdgeInsets.all(16),

            itemCount: docs.length,


            itemBuilder: (context, index) {


              final data =
              docs[index].data()
              as Map<String, dynamic>;



              return Card(

                child: ListTile(


                  leading: const Icon(Icons.groups),


                  title: Text(
                    data['team name'] ?? '',
                  ),


                  subtitle: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

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

                ),

              );


            },

          );


        },

      ),

    );

  }

}