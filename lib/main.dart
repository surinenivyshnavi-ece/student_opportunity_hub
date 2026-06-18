import 'package:flutter/material.dart';
import 'internships_page.dart';
import 'hackathons_page.dart';
import 'team formation_page.dart';
import 'profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(

    options: DefaultFirebaseOptions.currentPlatform,

  );


  runApp(const MyApp());

}





class MyApp extends StatelessWidget {

  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {


    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Student Opportunity Hub',

      home: const AuthCheck(),

    );

  }

}





class AuthCheck extends StatelessWidget {

  const AuthCheck({super.key});


  @override
  Widget build(BuildContext context) {

    return StreamBuilder<User?>(

      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {


        if (snapshot.connectionState ==
            ConnectionState.waiting) {

          return const Scaffold(

            body: Center(

              child: CircularProgressIndicator(),

            ),

          );

        }


        if (snapshot.data != null) {

          return const HomePage();

        }


        return const LoginPage();


      },

    );

  }

}






// ================= HOME PAGE =================


class HomePage extends StatelessWidget {


  const HomePage({super.key});



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor: const Color(0xffE3F2FD),




      appBar: AppBar(


        centerTitle: true,


        backgroundColor: Colors.white,


        elevation: 0,



        title: const Text(

          'Student Opportunity Hub',

          style: TextStyle(

            fontWeight: FontWeight.bold,

            color: Colors.black,

          ),

        ),




        iconTheme: const IconThemeData(

          color: Colors.black,

        ),




        actions: [



          IconButton(


            icon: const Icon(Icons.logout),


            onPressed: () async {


              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();


            },


          ),



        ],



      ),





      body: Center(



        child: SingleChildScrollView(



          child: Padding(



            padding: const EdgeInsets.all(20),



            child: Column(



              mainAxisAlignment:
              MainAxisAlignment.center,



              children: [




                Image.asset(

                  'assets/images/logo.png',

                  height:120,

                ),





                const SizedBox(height:15),






                const Text(



                  "🎓 Welcome to Student Opportunity Hub",



                  style: TextStyle(



                    fontSize:22,



                    fontWeight: FontWeight.bold,



                  ),



                  textAlign: TextAlign.center,



                ),





                const SizedBox(height:10),





                const Text(



                  "Find internships, hackathons, teammates and opportunities.",



                  textAlign: TextAlign.center,



                ),






                const SizedBox(height:30),





                buildButton(

                  context,

                  "📚 Internships",

                  InternshipsPage(),

                ),





                const SizedBox(height:15),





                buildButton(

                  context,

                  "🏆 Hackathons",

                  HackathonsPage(),

                ),






                const SizedBox(height:15),






                buildButton(

                  context,

                  "👥 Team Formation",

                  TeamFormationPage(),

                ),






                const SizedBox(height:15),





                buildButton(

                  context,

                  "👤 Profile",

                  ProfilePage(),

                ),






                const SizedBox(height:30),






                const Text(



                  "Built by Team Student Opportunity Hub",



                  style: TextStyle(



                    fontSize:12,



                    color:Colors.grey,



                  ),



                ),



              ],


            ),


          ),


        ),


      ),


    );


  }







  Widget buildButton(


      BuildContext context,


      String text,


      Widget page,


      ) {



    return SizedBox(


      width:280,



      child: ElevatedButton(



        style: ElevatedButton.styleFrom(



          backgroundColor: Colors.white,



          foregroundColor: Colors.black,



          elevation:3,



          padding: const EdgeInsets.all(18),



          shape: RoundedRectangleBorder(



            borderRadius: BorderRadius.circular(12),



            side: const BorderSide(

              color: Colors.grey,

            ),



          ),



        ),



        onPressed: () {



          Navigator.push(



            context,



            MaterialPageRoute(



              builder:(context)=>page,



            ),



          );



        },



        child: Text(



          text,



          style: const TextStyle(



            fontSize:18,



            fontWeight: FontWeight.bold,



          ),



        ),



      ),



    );


  }


}