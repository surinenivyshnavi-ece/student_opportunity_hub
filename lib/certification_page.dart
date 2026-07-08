import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'opportunity_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_certification_page.dart';



class CertificationPage extends StatefulWidget {

  const CertificationPage({super.key});


  @override
  State<CertificationPage> createState() =>
      _CertificationPageState();

}



class _CertificationPageState extends State<CertificationPage>{


  final CollectionReference certificationRef =
  FirebaseFirestore.instance.collection('certifications');


  String searchText = "";

  String selectedDomain = "All";

  String selectedMode = "All";
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  Future<void> checkAdmin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final adminDoc = await FirebaseFirestore.instance
        .collection("admins")
        .doc(user.uid)
        .get();

    if (adminDoc.exists) {
      setState(() {
        isAdmin = true;
      });
    }
  }



  @override
  Widget build(BuildContext context){


    return Scaffold(
      backgroundColor: const Color(0xFF9EB294),

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "🏆 Certifications",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


      body: Column(

        children: [



          Padding(
            padding: const EdgeInsets.fromLTRB(16,16,16,10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    offset: const Offset(0,4),
                  ),
                ],
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Search Certifications",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical:16),
                ),
                onChanged: (value) {
                  setState(() {
                    searchText = value.toLowerCase();
                  });
                },
              ),
            ),
          ),



          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(

            children:[


              Expanded(

           child: Container(
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonFormField(
            isExpanded: true,
          value: selectedDomain,
          decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          ),
          items: const [


                    DropdownMenuItem(
                      value:"All",
                      child:Text("All"),
                    ),


                    DropdownMenuItem(
                      value:"Programming",
                      child:Text("Programming"),
                    ),


                    DropdownMenuItem(
                      value:"App Development",
                      child:Text("App Development"),
                    ),


                    DropdownMenuItem(
                      value:"AI/ML",
                      child:Text("AI/ML"),
                    ),


                  ],


                  onChanged:(value){

                    setState((){

                      selectedDomain=value!;

                    });

                  },


                ),


               ),
    ),
    const SizedBox(width: 10),




              Expanded(

           child: Container(
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    ),
    child: DropdownButtonFormField(
      isExpanded: true,
    value: selectedMode,
    decoration: const InputDecoration(
    border: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(horizontal: 16),
    ),
    items: const [


                    DropdownMenuItem(
                      value:"All",
                      child:Text("All"),
                    ),


                    DropdownMenuItem(
                      value:"Online",
                      child:Text("Online"),
                    ),


                    DropdownMenuItem(
                      value:"Offline",
                      child:Text("Offline"),
                    ),


                  ],


                  onChanged:(value){

                    setState((){

                      selectedMode=value!;

                    });

                  },


                ),

              ),





          ),
            ],
            ),
          ),







          Expanded(

            child: StreamBuilder<QuerySnapshot>(


              stream: certificationRef.snapshots(),


              builder:(context,snapshot){


                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text("No data"),
                  );
                }



                final docs =
                snapshot.data!.docs.where((doc){


                  final data =
                  doc.data() as Map<String,dynamic>;



                  final title =
                  (data['title']??'')
                      .toString()
                      .toLowerCase();



                  final domain =
                  (data['domain']??'')
                      .toString();



                  final mode =
                  (data['mode']??'')
                      .toString();



                  return

                    (title.contains(searchText))

                        &&

                        (selectedDomain=="All" ||
                            domain==selectedDomain)

                        &&

                        (selectedMode=="All" ||
                            mode==selectedMode);



                }).toList();



                return ListView.builder(

                  itemCount:docs.length,


                  itemBuilder:(context,index){



                    final data =
                    docs[index].data()
                    as Map<String,dynamic>;



                    return Card(
                      color:  const Color(0xFFE9F5DB),
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
                              builder: (_) =>
                                  OpportunityDetailsPage(data: data),
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
                                    backgroundColor: Colors.orange.shade100,
                                    child: const Icon(
                                      Icons.workspace_premium,
                                      color: Colors.orange,
                                    ),
                                  ),

                                  const SizedBox(width: 14),

                                  Expanded(
                                    child: Text(
                                      data['title'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              Text(
                                data['platform'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [

                                  Chip(
                                    avatar: const Icon(Icons.computer,size:18),
                                    label: Text(data['domain'] ?? ''),
                                  ),

                                  Chip(
                                    avatar: const Icon(Icons.schedule,size:18),
                                    label: Text(data['duration'] ?? ''),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 10),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  IconButton(
                                    icon: const Icon(Icons.bookmark_border),
                                    onPressed: () async {
                                      final user = FirebaseAuth.instance.currentUser;
                                      if (user == null) return;

                                      await FirebaseFirestore.instance
                                          .collection('bookmarks')
                                          .doc(user.uid)
                                          .collection('saved')
                                          .doc(docs[index].id)
                                          .set({
                                        ...data,
                                        "type": "certification",
                                      });

                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("Certification bookmarked"),
                                          ),
                                        );
                                      }
                                    },
                                  ),

                                  if (isAdmin)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AddCertificationPage(
                                              documentId: docs[index].id,
                                              certificationData: data,
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                  if (isAdmin)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () async {
                                        bool? confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Delete Certification"),
                                              content: const Text(
                                                "Are you sure you want to delete this certification?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, false);
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context, true);
                                                  },
                                                  child: const Text("Delete"),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        if (confirm == true) {
                                          await FirebaseFirestore.instance
                                              .collection('certifications')
                                              .doc(docs[index].id)
                                              .delete();

                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text("Certification deleted successfully"),
                                              ),
                                            );
                                          }
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
              builder: (_) =>
              const AddCertificationPage(),
            ),
          );
        },
      )
          : null,


    );


  }


}