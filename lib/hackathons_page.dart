import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_hackathon_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'opportunity_details_page.dart';
import 'package:share_plus/share_plus.dart';


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
      backgroundColor: const Color(0xFF9EB294),

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
          ? FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddHackathonPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
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
                      color: const Color(0xFFE9F5DB),
                      elevation: 2,
                      shadowColor: Colors.black12,
                      margin: const EdgeInsets.only(bottom: 16),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.orange.shade100,
                                    child: Icon(
                                      Icons.emoji_events,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(
                                          data['title'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          data['organizer'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('bookmarks')
                                        .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
                                        .collection('saved')
                                        .doc(docs[index].id)
                                        .snapshots(),
                                    builder: (context, snapshot) {

                                      bool isBookmarked = snapshot.data?.exists ?? false;

                                      return IconButton(
                                        icon: Icon(
                                          isBookmarked
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                        ),
                                        onPressed: () {
                                          toggleBookmark(
                                            docs[index].id,
                                            data,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
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

                              const SizedBox(height: 12),

                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [

                                  Chip(label: Text(data['mode'] ?? '')),

                                  Chip(label: Text(data['teamSize'] ?? '')),

                                  Chip(label: Text(data['prize'] ?? '')),

                                ],
                              ),

                              const SizedBox(height: 12),

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

                                  const Spacer(),

                                  if (isAdmin)
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
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

                                  if (isAdmin)
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        bool? confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text("Confirm Delete"),
                                            content: const Text(
                                              "Are you sure you want to delete this hackathon?",
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
                                          await hackathonsRef.doc(docs[index].id).delete();
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


    );

  }

}