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
  String selectedMode = "All";
  String selectedDomain = "All";

  bool isAdmin = false;


  @override
  void initState() {
    super.initState();
    checkAdmin();
  }
  Future<void> toggleBookmark(
      String docId,
      Map<String, dynamic> data,
      ) async {

    final user = FirebaseAuth.instance.currentUser;

    if(user == null) return;


    final bookmarkRef = FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(user.uid)
        .collection('saved')
        .doc(docId);


    final bookmark = await bookmarkRef.get();


    if(bookmark.exists){

      await bookmarkRef.delete();


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text("Removed from bookmarks"),
        ),

      );


    }

    else{


      await bookmarkRef.set({

        ...data,

        'type':'hackathon',

        'bookmarkedAt':
        FieldValue.serverTimestamp(),

      });



      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text("Added to bookmarks"),
        ),

      );


    }

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
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "🏆 Hackathons",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),




      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Add"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddHackathonPage(),
            ),
          );
        },
      )
          : null,



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
            hintText: "Search Hackathons",
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


          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [

                SizedBox(
                  width: 140,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedMode,
                    decoration: InputDecoration(
                      labelText: "Mode",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "All", child: Text("All")),
                      DropdownMenuItem(value: "Online", child: Text("Online")),
                      DropdownMenuItem(value: "Offline", child: Text("Offline")),
                      DropdownMenuItem(value: "Hybrid", child: Text("Hybrid")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedMode = value!;
                      });
                    },
                  ),
                ),

                SizedBox(
                  width: 140,
                  child: DropdownButtonFormField<String>(
                    isExpanded:true,
                    value: selectedDomain,
                    decoration: InputDecoration(
                      labelText: "Domain",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "All", child: Text("All")),
                      DropdownMenuItem(value: "AI/ML", child: Text("AI/ML")),
                      DropdownMenuItem(value: "Web Development", child: Text("Web Dev")),
                      DropdownMenuItem(value: "Data Science", child: Text("Data Science")),
                      DropdownMenuItem(value: "Cyber Security", child: Text("Cyber Security")),
                      DropdownMenuItem(value: "Embedded Systems", child: Text("Embedded")),
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

                  final mode =
                  (data['mode'] ?? '')
                      .toString();

                  bool searchMatch =
                      title.contains(searchText) ||
                          organizer.contains(searchText) ||
                          domain.contains(searchText);

                  bool modeMatch =
                      selectedMode == "All" ||
                          mode == selectedMode;

                  bool domainMatch =
                      selectedDomain == "All" ||
                          domain.toLowerCase() ==
                              selectedDomain.toLowerCase();

                  return searchMatch &&
                      modeMatch &&
                      domainMatch;



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
                      color: Colors.white,
                      elevation: 2,
                      shadowColor: Colors.black12,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),



                      child: ListTile(


                        leading: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.orange.shade100,
                          child: Icon(
                            Icons.emoji_events,
                            color: Colors.orange.shade700,
                          ),
                        ),



                        title: Text(
                          data['title'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                data['organizer'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [

                                  Chip(
                                    avatar: const Icon(Icons.public, size: 18),
                                    label: Text(data['mode'] ?? ''),
                                  ),

                                  Chip(
                                    avatar: const Icon(Icons.group, size: 18),
                                    label: Text(data['teamSize'] ?? ''),
                                  ),

                                  Chip(
                                    avatar: const Icon(Icons.workspace_premium, size: 18),
                                    label: Text(data['prize'] ?? ''),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [

                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.red,
                                    size: 16,
                                  ),

                                  const SizedBox(width: 6),

                                  Text(
                                    data['deadline'] ?? '',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                ],
                              ),

                            ],
                          ),
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





                        trailing: SizedBox(

                          width: isAdmin ? 160 : 60,

                          child: Row(

                            mainAxisSize: MainAxisSize.min,

                            children: [



                              StreamBuilder<DocumentSnapshot>(


                                stream: FirebaseFirestore.instance

                                    .collection('bookmarks')

                                    .doc(FirebaseAuth.instance.currentUser?.uid ?? '')

                                    .collection('saved')

                                    .doc(docs[index].id)

                                    .snapshots(),



                                builder:(context,snapshot){


                                  bool isBookmarked =
                                      snapshot.data?.exists ?? false;



                                  return IconButton(


                                    icon: Icon(

                                      isBookmarked

                                          ? Icons.bookmark_rounded

                                          : Icons.bookmark_border_rounded,

                                    ),



                                    onPressed:(){


                                      toggleBookmark(

                                        docs[index].id,

                                        data,

                                      );


                                    },



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
                                        builder: (_) => AddHackathonPage(
                                          documentId: docs[index].id,
                                          hackathonData: data,
                                        ),
                                      ),
                                    );
                                  },
                                ),




                              if(isAdmin)


                                IconButton(


                                  icon: const Icon(Icons.delete),



                                  onPressed:() async {



                                    bool? confirm = await showDialog<bool>(


                                      context:context,


                                      builder:(context)=>AlertDialog(


                                        title:
                                        const Text("Confirm Delete"),



                                        content:
                                        const Text(
                                            "Are you sure you want to delete this hackathon?"
                                        ),



                                        actions:[


                                          TextButton(

                                            onPressed:(){

                                              Navigator.pop(context,false);

                                            },

                                            child:
                                            const Text("Cancel"),

                                          ),



                                          TextButton(

                                            onPressed:(){

                                              Navigator.pop(context,true);

                                            },

                                            child:
                                            const Text("Delete"),

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


    );

  }

}