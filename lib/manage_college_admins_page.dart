import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_college_admin_page.dart';


class ManageCollegeAdminsPage extends StatelessWidget {

  const ManageCollegeAdminsPage({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Manage College Admins"),
      ),


      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection("admins")
            .where("role", isEqualTo: "collegeAdmin")
            .snapshots(),


        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


          final admins = snapshot.data!.docs;


          if (admins.isEmpty) {
            return const Center(
              child: Text("No College Admins Found"),
            );
          }


          return ListView.builder(

            itemCount: admins.length,


            itemBuilder: (context, index) {
              final admin =
              admins[index].data() as Map<String, dynamic>;


              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        admin["name"] ?? "",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text("Email: ${admin["email"]}"),
                      Text("College: ${admin["college"]}"),
                      Text("Status: ${admin["status"] ?? "active"}"),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditCollegeAdminPage(
                                        adminId: admins[index].id,
                                        adminData: admin,
                                      ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(width: 10),

                          ElevatedButton(
                            onPressed: () async {
                              String currentStatus = admin["status"] ??
                                  "active";

                              await admins[index].reference.update({
                                "status": currentStatus == "active"
                                    ? "inactive"
                                    : "active",
                              });
                            },
                            child: Text(
                              (admin["status"] ?? "active") == "active"
                                  ? "Deactivate"
                                  : "Activate",
                            ),
                          ),

                        ],
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