import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentVerificationPage extends StatefulWidget {
  const StudentVerificationPage({super.key});

  @override
  State<StudentVerificationPage> createState() =>
      _StudentVerificationPageState();
}

class _StudentVerificationPageState extends State<StudentVerificationPage> {

  String? adminCollege;

  @override
  void initState() {
    super.initState();
    getAdminCollege();
  }


  Future<void> getAdminCollege() async {

    final uid = FirebaseAuth.instance.currentUser!.uid;

    final adminDoc = await FirebaseFirestore.instance
        .collection("admins")
        .doc(uid)
        .get();


    if (adminDoc.exists) {

      setState(() {
        adminCollege = adminDoc["college"];
      });

    }
  }


  @override
  Widget build(BuildContext context) {

    if (adminCollege == null) {

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );

    }


    return Scaffold(

      appBar: AppBar(
        title: const Text("Student Verifications"),
      ),


      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("users")
            .where("status", isEqualTo: "pending")
            .where("college", isEqualTo: adminCollege)
            .snapshots(),


        builder: (context, snapshot) {


          if (!snapshot.hasData) {

            return const Center(
              child: CircularProgressIndicator(),
            );

          }


          final students = snapshot.data!.docs;


          if (students.isEmpty) {

            return const Center(
              child: Text("No Pending Verifications"),
            );

          }



          return ListView.builder(

            itemCount: students.length,


            itemBuilder: (context,index){


              final student =
              students[index].data() as Map<String,dynamic>;



              return Card(

                margin: const EdgeInsets.all(10),


                child: ListTile(

                  title: Text(student["name"] ?? ""),


                  subtitle: Column(

                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text("College: ${student["college"]}"),

                      Text("Branch: ${student["branch"]}"),

                      Text("Year: ${student["year"]}"),

                      Text("Roll No: ${student["rollNo"]}"),

                    ],

                  ),


                  trailing: Row(

                    mainAxisSize: MainAxisSize.min,


                    children: [


                      ElevatedButton(

                        onPressed: () async {

                          await students[index]
                              .reference
                              .update({

                            "verified": true,

                            "status": "approved",

                          });

                        },


                        child: const Text("Approve"),

                      ),



                      const SizedBox(width:8),



                      ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),


                        onPressed: () async {


                          final controller =
                          TextEditingController();



                          final result =
                          await showDialog<bool>(

                            context: context,


                            builder:(context){


                              return AlertDialog(

                                title:
                                const Text("Reject Student"),


                                content: TextField(

                                  controller: controller,

                                  maxLines:3,

                                  decoration:
                                  const InputDecoration(

                                    hintText:
                                    "Enter rejection reason",

                                  ),

                                ),



                                actions:[


                                  TextButton(

                                    onPressed:(){

                                      Navigator.pop(
                                          context,false);

                                    },


                                    child:
                                    const Text("Cancel"),

                                  ),



                                  ElevatedButton(

                                    onPressed:(){

                                      Navigator.pop(
                                          context,true);

                                    },


                                    child:
                                    const Text("Reject"),

                                  ),


                                ],

                              );


                            },


                          );



                          if(result==true){


                            await students[index]
                                .reference
                                .update({

                              "verified":false,

                              "status":"rejected",

                              "rejectionReason":
                              controller.text.trim(),

                            });


                          }


                        },


                        child: const Text(
                          "Reject",
                          style:
                          TextStyle(color:Colors.white),
                        ),

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