import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_hackathon_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'opportunity_details_page.dart';


class HackathonsPage extends StatefulWidget {
  const HackathonsPage({super.key});

  @override
  State<HackathonsPage> createState() => _HackathonsPageState();
}


class _HackathonsPageState extends State<HackathonsPage> {

  final CollectionReference hackathonsRef =
  FirebaseFirestore.instance.collection('hackathons');

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

        title: const Text("Hackathons"),

        actions: [

          if(isAdmin)

            IconButton(

              icon: const Icon(Icons.add),

              onPressed: (){

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder:(context)=>
                    const AddHackathonPage(),

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

                hintText: "Search Hackathons...",

                prefixIcon: Icon(Icons.search),

                border: OutlineInputBorder(),

              ),


              onChanged:(value){

                setState((){

                  searchText=value.toLowerCase();

                });

              },


            ),

          ),




          Expanded(

            child: StreamBuilder<QuerySnapshot>(

              stream: hackathonsRef.snapshots(),


              builder:(context,snapshot){


                if(snapshot.connectionState ==
                    ConnectionState.waiting){

                  return const Center(
                    child:CircularProgressIndicator(),
                  );

                }



                final docs =
                snapshot.data!.docs.where((doc){


                  final data =
                  doc.data() as Map<String,dynamic>;

                  final title =
                  (data['title'] ?? '')
                      .toString()
                      .toLowerCase();

                  final organizer =
                  (data['organizer'] ?? '')
                      .toString()
                      .toLowerCase();

                  final domain =
                  (data['domain'] ?? '')
                      .toString()
                      .toLowerCase();

                  return title.contains(searchText) ||
                      organizer.contains(searchText) ||
                      domain.contains(searchText);



                }).toList();




                if(docs.isEmpty){

                  return const Center(

                    child:Text(
                      "No hackathons found",
                    ),

                  );

                }




                return ListView.builder(


                  padding: const EdgeInsets.all(16),


                  itemCount: docs.length,


                  itemBuilder:(context,index){


                    final data =
                    docs[index].data()
                    as Map<String,dynamic>;



                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),


                      child: ListTile(


                        leading:
                        const Icon(Icons.emoji_events),



                        title: Text(
                          data['title'] ?? '',
                        ),

                        subtitle: Text(
                          "Organizer: ${data['organizer'] ?? ''}\n"
                              "Prize: ${data['prize'] ?? ''}\n"
                              "Team Size: ${data['teamSize'] ?? ''}\n"
                              "Deadline: ${data['deadline'] ?? ''}",
                        ),




                        onTap:(){


                          Navigator.push(


                            context,


                            MaterialPageRoute(


                              builder:(context)=>

                                  OpportunityDetailsPage(
                                    data: data,
                                  ),


                            ),


                          );


                        },





                        trailing:isAdmin


                            ? IconButton(


                          icon:
                          const Icon(Icons.delete),



                          onPressed:() async {



                            bool? confirm =
                            await showDialog(


                              context:context,


                              builder:(context)=>

                                  AlertDialog(


                                    title:
                                    const Text(
                                        "Confirm Delete"
                                    ),


                                    content:
                                    const Text(
                                      "Are you sure you want to delete this hackathon?",
                                    ),



                                    actions:[



                                      TextButton(


                                        onPressed:(){

                                          Navigator.pop(
                                              context,false);

                                        },


                                        child:
                                        const Text(
                                            "Cancel"
                                        ),


                                      ),



                                      TextButton(


                                        onPressed:(){

                                          Navigator.pop(
                                              context,true);

                                        },


                                        child:
                                        const Text(
                                            "Delete"
                                        ),


                                      ),


                                    ],


                                  ),


                            );



                            if(confirm == true){


                              await hackathonsRef
                                  .doc(docs[index].id)
                                  .delete();


                            }


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