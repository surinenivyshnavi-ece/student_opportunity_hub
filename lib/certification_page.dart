import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'opportunity_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_certification_page.dart';
import 'package:share_plus/share_plus.dart';



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
              DropdownMenuItem(value: "All", child: Text("All")),
              DropdownMenuItem(value: "AI/ML", child: Text("AI/ML")),
              DropdownMenuItem(value: "Data Science", child: Text("Data Science")),
              DropdownMenuItem(value: "App Development", child: Text("App Development")),
              DropdownMenuItem(value: "Web Development", child: Text("Web Development")),
              DropdownMenuItem(value: "Embedded Systems", child: Text("Embedded Systems")),
              DropdownMenuItem(value: "IoT", child: Text("Internet of Things (IoT)")),
              DropdownMenuItem(value: "Cyber Security", child: Text("Cyber Security")),
              DropdownMenuItem(value: "Cloud Computing", child: Text("Cloud Computing")),
              DropdownMenuItem(value: "DevOps", child: Text("DevOps")),
              DropdownMenuItem(value: "Blockchain", child: Text("Blockchain")),
              DropdownMenuItem(value: "Robotics", child: Text("Robotics")),
              DropdownMenuItem(value: "AR/VR", child: Text("AR/VR")),
              DropdownMenuItem(value: "Game Development", child: Text("Game Development")),
              DropdownMenuItem(value: "Computer Vision", child: Text("Computer Vision")),
              DropdownMenuItem(value: "NLP", child: Text("Natural Language Processing")),
              DropdownMenuItem(value: "Electronics", child: Text("Electronics")),
              DropdownMenuItem(value: "VLSI", child: Text("VLSI")),
              DropdownMenuItem(value: "Communication Systems", child: Text("Communication Systems")),
              DropdownMenuItem(value: "Signal Processing", child: Text("Signal Processing")),
              DropdownMenuItem(value: "Control Systems", child: Text("Control Systems")),
              DropdownMenuItem(value: "Automation", child: Text("Automation")),
              DropdownMenuItem(value: "Electrical", child: Text("Electrical Engineering")),
              DropdownMenuItem(value: "Mechanical", child: Text("Mechanical Engineering")),
              DropdownMenuItem(value: "Civil", child: Text("Civil Engineering")),
              DropdownMenuItem(value: "Chemical", child: Text("Chemical Engineering")),
              DropdownMenuItem(value: "Biomedical", child: Text("Biomedical Engineering")),
              DropdownMenuItem(value: "Aerospace", child: Text("Aerospace Engineering")),
              DropdownMenuItem(value: "Automobile", child: Text("Automobile Engineering")),
              DropdownMenuItem(value: "3D Printing", child: Text("3D Printing")),
              DropdownMenuItem(value: "Renewable Energy", child: Text("Renewable Energy")),
              DropdownMenuItem(value: "Smart Agriculture", child: Text("Smart Agriculture")),
              DropdownMenuItem(value: "FinTech", child: Text("FinTech")),
              DropdownMenuItem(value: "EdTech", child: Text("EdTech")),
              DropdownMenuItem(value: "HealthTech", child: Text("HealthTech")),
              DropdownMenuItem(value: "UI/UX Design", child: Text("UI/UX Design")),
              DropdownMenuItem(value: "Product Design", child: Text("Product Design")),
              DropdownMenuItem(value: "Digital Marketing", child: Text("Digital Marketing")),
              DropdownMenuItem(value: "Entrepreneurship", child: Text("Entrepreneurship")),
              DropdownMenuItem(value: "Open Innovation", child: Text("Open Innovation")),
              DropdownMenuItem(value: "Research", child: Text("Research")),
              DropdownMenuItem(value: "General", child: Text("General")),
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
                  (data['title'] ?? '')
                      .toString()
                      .toLowerCase();

                  final platform =
                  (data['platform'] ?? '')
                      .toString()
                      .toLowerCase();

                  final domain =
                  (data['domain'] ?? '')
                      .toString();

                  final mode =
                  (data['mode'] ?? '')
                      .toString();

                  final description =
                  (data['description'] ?? '')
                      .toString()
                      .toLowerCase();

                  return
                    (
                        title.contains(searchText) ||
                            platform.contains(searchText) ||
                            description.contains(searchText)
                    )
                        &&
                        (selectedDomain == "All" || domain == selectedDomain)
                        &&
                        (selectedMode == "All" || mode == selectedMode);



                }).toList();
                if (docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Certifications Found",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }



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
                                  IconButton(
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      SharePlus.instance.share(
                                        ShareParams(
                                          text: '''
🏆 ${data['title']}

Platform: ${data['platform']}
Domain: ${data['domain']}
Duration: ${data['duration']}

${data['description']}

Apply Here:
${data['link']}
''',
                                        ),
                                      );
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