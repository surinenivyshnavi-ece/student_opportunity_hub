import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'opportunity_details_page.dart';


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



  @override
  Widget build(BuildContext context){


    return Scaffold(

      appBar: AppBar(

        title: const Text("Certification Courses"),

      ),


      body: Column(

        children: [



          Padding(

            padding: const EdgeInsets.all(10),

            child: TextField(

              decoration: const InputDecoration(

                hintText:"Search Courses",

                prefixIcon:Icon(Icons.search),

                border:OutlineInputBorder(),

              ),


              onChanged:(value){

                setState((){

                  searchText=value.toLowerCase();

                });

              },


            ),

          ),



          Row(

            children:[


              Expanded(

                child: DropdownButtonFormField(

                  value:selectedDomain,

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



              Expanded(

                child: DropdownButtonFormField(

                  value:selectedMode,

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


            ],


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

                      child:ListTile(


                        leading:
                        const Icon(Icons.workspace_premium),



                        title:Text(
                            data['title']??''
                        ),



                        subtitle:Text(

                          "Platform: ${data['platform']??''}\n"
                              "Domain: ${data['domain']??''}\n"
                              "Duration: ${data['duration']??''}",

                        ),



                        onTap:(){


                          Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder:(context)=>
                                  OpportunityDetailsPage(
                                    data:data,
                                  ),

                            ),

                          );


                        },



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