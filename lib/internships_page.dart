import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'add_internship_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'opportunity_details_page.dart';
import 'package:share_plus/share_plus.dart';

class InternshipsPage extends StatefulWidget {
  const InternshipsPage({super.key});

  @override
  State<InternshipsPage> createState() => _InternshipsPageState();
}

class _InternshipsPageState extends State<InternshipsPage> {

  final CollectionReference internshipsRef =
  FirebaseFirestore.instance.collection('internships');
  final FirebaseAuth auth = FirebaseAuth.instance;

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
    final user = auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please login first"),
        ),
      );
      return;
    }

    final bookmarkRef = FirebaseFirestore.instance
        .collection('bookmarks')
        .doc(user.uid)
        .collection('saved')
        .doc(docId);

    final bookmark = await bookmarkRef.get();

    if (bookmark.exists) {
      await bookmarkRef.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Removed from bookmarks"),
        ),
      );
    } else {
      await bookmarkRef.set({
        ...data,
        'type': 'internship',
        'bookmarkedAt': FieldValue.serverTimestamp(),
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
      backgroundColor: const Color(0xFF9EB294),


      appBar: AppBar(


        title: const Text("Internships"),




      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddInternshipPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,




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
                              builder: (context) => OpportunityDetailsPage(
                                data: data,
                              ),
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
                                    child: Icon(
                                      Icons.work,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Text(
                                      data['title'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('bookmarks')
                                        .doc(auth.currentUser?.uid ?? '')
                                        .collection('saved')
                                        .doc(docs[index].id)
                                        .snapshots(),
                                    builder: (context, snapshot) {

                                      bool isBookmarked =
                                          snapshot.data?.exists ?? false;

                                      return IconButton(
                                        icon: Icon(
                                          isBookmarked
                                              ? Icons.bookmark_rounded
                                              : Icons.bookmark_border_rounded,
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
                                            builder: (_) => AddInternshipPage(
                                              documentId: docs[index].id,
                                              internshipData: data,
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                  if (isAdmin)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.black38,
                                      ),
                                      onPressed: () async {

                                        bool? confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: const Text("Confirm Delete"),
                                            content: const Text(
                                                "Are you sure you want to delete this internship?"),
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
                                          await internshipsRef
                                              .doc(docs[index].id)
                                              .delete();
                                        }
                                      },
                                    ),

                                ],
                              ),

                              const SizedBox(height: 12),

                              Text(
                                data['company'] ?? '',
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
                                    avatar: const Icon(Icons.location_on, size: 18),
                                    label: Text(data['location'] ?? ''),
                                  ),

                                  Chip(
                                    avatar: const Icon(Icons.currency_rupee, size: 18),
                                    label: Text(data['stipend'] ?? ''),
                                  ),

                                  Chip(
                                    avatar: const Icon(Icons.public, size: 18),
                                    label: Text(data['mode'] ?? ''),
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