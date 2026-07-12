import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminRequestsPage extends StatelessWidget {

  const AdminRequestsPage({super.key});


  Future<void> approveRequest(
      BuildContext context,
      DocumentSnapshot request,
      ) async {
    try {
      final data = request.data() as Map<String, dynamic>;

      await FirebaseFirestore.instance
          .collection("admins")
          .doc(data["uid"])
          .set({
        "uid": data["uid"],
        "name": data["name"],
        "email": data["email"],
        "college": data["college"],
        "branch": data["branch"],
        "role": "college_admin",
        "approvedAt": Timestamp.now(),
      });

      await FirebaseFirestore.instance
          .collection("admin_requests")
          .doc(request.id)
          .update({
        "status": "approved",
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Admin approved")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }



  Future<void> rejectRequest(
      BuildContext context,
      String id,
      ) async {


    await FirebaseFirestore.instance
        .collection("admin_requests")
        .doc(id)
        .update({

      "status": "rejected",

    });


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Request rejected"),
      ),
    );

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Admin Requests",
        ),
      ),


      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("admin_requests")
            .where(
          "status",
          isEqualTo: "pending",
        )
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
                "No pending requests",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );

          }


          return ListView.builder(

            itemCount:
            snapshot.data!.docs.length,


            itemBuilder: (context,index){


              final request =
              snapshot.data!.docs[index];


              final data =
              request.data()
              as Map<String,dynamic>;



              return Card(

                margin:
                const EdgeInsets.all(12),


                child: ListTile(

                  title: Text(
                    data["name"] ?? "",
                  ),


                  subtitle: Text(
                    "${data["college"]}\n${data["email"]}",
                  ),


                  isThreeLine: true,


                  trailing: Row(

                    mainAxisSize:
                    MainAxisSize.min,


                    children: [

                      IconButton(
                        icon:
                        const Icon(
                          Icons.check,
                        ),

                        onPressed: (){

                          approveRequest(
                            context,
                            request,
                          );

                        },

                      ),



                      IconButton(
                        icon:
                        const Icon(
                          Icons.close,
                        ),

                        onPressed: (){

                          rejectRequest(
                            context,
                            request.id,
                          );

                        },

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