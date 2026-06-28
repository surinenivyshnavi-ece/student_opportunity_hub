import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_team_formation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'opportunity_details_page.dart';


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

  bool isAdmin = false;



  @override
  void initState() {
    super.initState();
    checkAdmin();
  }



  Future<void> checkAdmin() async {


    final user = FirebaseAuth.instance.currentUser;


    if(user == null) return;



    final adminDoc = await FirebaseFirestore.instance
        .collection('admins')
        .doc(user.uid)
        .get();



    if(adminDoc.exists){


      setState(() {

        isAdmin = true;

      });


    }


  }







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
                  builder: (context) => const AddTeamFormationPage(),
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



              onChanged:(value){



                setState((){


                  searchText =
                      value.toLowerCase();


                });


              },



            ),



          ),







          Expanded(



            child: StreamBuilder<QuerySnapshot>(



              stream: teamRef.snapshots(),



              builder:(context,snapshot){



                if(snapshot.hasError){


                  return const Center(


                    child:Text(
                        "Something went wrong"
                    ),


                  );


                }







                if(snapshot.connectionState ==
                    ConnectionState.waiting){


                  return const Center(


                    child:CircularProgressIndicator(),


                  );


                }







                final docs =
                snapshot.data!.docs.where((doc){

                  final data =
                  doc.data() as Map<String, dynamic>;







                  final teamName =
                  (data['teamName'] ?? '')
                      .toString()
                      .toLowerCase();




                  final skill =
                  (data['requiredSkill'] ?? '')
                      .toString()
                      .toLowerCase();





                  final preferredRole =
                  (data['preferredRole'] ?? '')
                      .toString()
                      .toLowerCase();

                  return teamName.contains(searchText) ||
                      skill.contains(searchText) ||
                      preferredRole.contains(searchText);



                }).toList();








                if(docs.isEmpty){


                  return const Center(


                    child:Text(
                        "No teams found"
                    ),


                  );


                }







                return ListView.builder(



                  padding:
                  const EdgeInsets.all(16),



                  itemCount:docs.length,



                  itemBuilder:(context,index){



                    final data =
                    docs[index].data()
                    as Map<String,dynamic>;
                    final currentUser = FirebaseAuth.instance.currentUser;

                    final isOwner =
                    currentUser != null &&
                    currentUser.uid == data['createdBy'];







                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),



                      child: ListTile(



                        leading:
                        const Icon(
                          Icons.groups,
                        ),






                        title: Text(
                          data['teamName'] ?? '',
                        ),






                        subtitle: Text(
                          "Required Skill: ${data['requiredSkill'] ?? ''}\n"
                              "Members Needed: ${data['membersNeeded'] ?? ''}\n"
                              "Preferred Role: ${data['preferredRole'] ?? ''}\n"
                              "Contact: ${data['contact'] ?? ''}",
                        ),






                        onTap:(){





                          Navigator.push(





                            context,





                            MaterialPageRoute(





                              builder:(context)=>

                                  OpportunityDetailsPage(
                                    data: data,
                                  )





                            ),





                          );





                        },









                        trailing: (isAdmin || isOwner)
                            ? SizedBox(
                          width: 96,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddTeamFormationPage(
                                        documentId: docs[index].id,
                                        teamData: data,
                                      ),
                                    ),
                                  );
                                },
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {

                                  bool? confirm = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Confirm Delete"),
                                      content: const Text(
                                        "Are you sure you want to delete this team?",
                                      ),
                                      actions: [

                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text("Cancel"),
                                        ),

                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text("Delete"),
                                        ),

                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await teamRef
                                        .doc(docs[index].id)
                                        .delete();
                                  }
                                },
                              ),

                            ],
                          ),
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