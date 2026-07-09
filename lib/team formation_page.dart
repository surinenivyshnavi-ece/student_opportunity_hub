import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_team_formation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'opportunity_details_page.dart';
import 'package:share_plus/share_plus.dart';


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
      backgroundColor: const Color(0xFF9EB294),


      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "👥 Team Formation",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),






      body: Column(



        children: [



          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search Teams...",
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
                      color: const Color(0xFFE9F5DB),
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
                                    backgroundColor: Colors.blue.shade100,
                                    child: const Icon(
                                      Icons.groups,
                                      color: Colors.blue,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Text(
                                      data['teamName'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              Text(
                                "Required Skill: ${data['requiredSkill'] ?? ''}",
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),

                              const SizedBox(height: 10),

                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [

                                  Chip(
                                    avatar: const Icon(Icons.code, size: 18),
                                    label: Text(data['requiredSkill'] ?? ''),
                                  ),

                                  Chip(
                                    avatar: const Icon(Icons.people, size: 18),
                                    label: Text(
                                      "${data['membersNeeded'] ?? ''} Members",
                                    ),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 12),

                              Row(
                                children: [

                                  const Icon(
                                    Icons.person,
                                    color: Colors.green,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 6),

                                  Expanded(
                                    child: Text(
                                      data['preferredRole'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Row(
                                children: [

                                  const Icon(
                                    Icons.phone,
                                    color: Colors.orange,
                                    size: 18,
                                  ),

                                  const SizedBox(width: 6),

                                  Expanded(
                                    child: Text(data['contact'] ?? ''),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              if (isAdmin || isOwner)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                            builder: (_) => AddTeamFormationPage(
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
                                          builder: (_) => AlertDialog(
                                            title: const Text("Confirm Delete"),
                                            content: const Text(
                                              "Are you sure you want to delete this team?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, false),
                                                child: const Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, true),
                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          await teamRef.doc(docs[index].id).delete();
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
              builder: (context) => const AddTeamFormationPage(),
            ),
          );
        },
      )
          : null,




    );



  }


}