import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_internship_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'opportunity_details_page.dart';

class InternshipsPage extends StatefulWidget {
  const InternshipsPage({super.key});

  @override
  State<InternshipsPage> createState() => _InternshipsPageState();
}

class _InternshipsPageState extends State<InternshipsPage> {

  final CollectionReference internshipsRef =
  FirebaseFirestore.instance.collection('internships');

  String searchText = '';
  String selectedMode = "All";
  String selectedDomain = "All";

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


    if(adminDoc.exists &&
        adminDoc.data()?['role'] == 'admin'){

      setState((){

        isAdmin = true;

      });

    }

  }



  Future<void> openLink(String link) async {

    final Uri url = Uri.parse(link);

    if(await canLaunchUrl(url)){
      await launchUrl(url);
    }

  }



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(


        title: const Text("Internships"),


        actions: [


          if(isAdmin)

            IconButton(

              icon: const Icon(Icons.add),

              onPressed: (){


                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder:(context)=>

                    const AddInternshipPage(),

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
                hintText: "Search Internships...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [

                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedMode,
                    decoration: const InputDecoration(
                      labelText: "Mode",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "All",
                        child: Text("All"),
                      ),
                      DropdownMenuItem(
                        value: "Online",
                        child: Text("Online"),
                      ),
                      DropdownMenuItem(
                        value: "Offline",
                        child: Text("Offline"),
                      ),
                      DropdownMenuItem(
                        value: "Hybrid",
                        child: Text("Hybrid"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedMode = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedDomain,
                    decoration: const InputDecoration(
                      labelText: "Domain",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "All",
                        child: Text("All"),
                      ),
                      DropdownMenuItem(
                        value: "AI/ML",
                        child: Text("AI/ML"),
                      ),
                      DropdownMenuItem(
                        value: "Web Development",
                        child: Text("Web Development"),
                      ),
                      DropdownMenuItem(
                        value: "Data Science",
                        child: Text("Data Science"),
                      ),
                      DropdownMenuItem(
                        value: "Embedded Systems",
                        child: Text("Embedded Systems"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedDomain = value!;
                      });
                    },
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(


            child: StreamBuilder<QuerySnapshot>(


              stream: internshipsRef.snapshots(),


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


                  final company =
                  (data['company'] ?? '')
                      .toString()
                      .toLowerCase();



                  final title =
                  (data['title'] ?? '')
                      .toString()
                      .toLowerCase();



                  final domain =
                  (data['domain'] ?? '')
                      .toString();

                  final mode =
                  (data['mode'] ?? '')
                      .toString();

                  bool searchMatch =
                      company.contains(searchText) ||
                          title.contains(searchText) ||
                          domain.toLowerCase().contains(searchText);

                  bool modeMatch =
                      selectedMode == "All" ||
                          mode == selectedMode;

                  bool domainMatch =
                      selectedDomain == "All" ||
                          domain == selectedDomain;

                  return searchMatch &&
                      modeMatch &&
                      domainMatch;


                }).toList();



                if(docs.isEmpty){

                  return const Center(
                    child:Text("No internships found"),
                  );

                }





                return ListView.builder(


                  itemCount:docs.length,


                  padding:const EdgeInsets.all(12),


                  itemBuilder:(context,index){



                    final data =
                    docs[index].data()
                    as Map<String,dynamic>;




                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),


                      child:ListTile(


                        leading:
                        const Icon(Icons.work),



                        title: Text(
                          data['title'] ?? '',
                        ),

                        subtitle: Text(
                          "Title: ${data['title'] ?? ''}\n"
                              "Location: ${data['location'] ?? ''}\n"
                              "Stipend: ${data['stipend'] ?? ''}\n"
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





                        trailing:isAdmin ?


                        IconButton(


                          icon:
                          const Icon(Icons.delete),



                          onPressed:() async {



                            bool? confirm =

                            await showDialog<bool>(


                              context:context,


                              builder:(context)=>

                                  AlertDialog(


                                    title:
                                    const Text(
                                        "Confirm Delete"
                                    ),


                                    content:
                                    const Text(
                                        "Are you sure you want to delete this internship?"
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



                                      TextButton(


                                        onPressed:(){

                                          Navigator.pop(
                                              context,true);

                                        },


                                        child:
                                        const Text("Delete"),


                                      ),


                                    ],


                                  ),


                            );




                            if(confirm==true){


                              await internshipsRef
                                  .doc(docs[index].id)
                                  .delete();


                            }



                          },


                        )


                            :null,



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