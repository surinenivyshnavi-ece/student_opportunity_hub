import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();

}


class _LoginPageState extends State<LoginPage> {


  bool isLoading = false;



  Future<void> signInWithGoogle() async {


    if(isLoading) return;


    setState(() {

      isLoading = true;

    });


    try {


      GoogleAuthProvider googleProvider =
      GoogleAuthProvider();



      await FirebaseAuth.instance
          .signInWithPopup(googleProvider);



    }


    catch(e){


      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(
              "Login failed: $e"
          ),

        ),

      );


    }


    finally{


      setState(() {

        isLoading = false;

      });


    }


  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text("Login"),

      ),



      body: Center(



        child: ElevatedButton.icon(



          icon: const Icon(Icons.login),



          label: isLoading

              ? const Text("Signing in...")

              : const Text("Sign in with Google"),




          onPressed: isLoading

              ? null

              : signInWithGoogle,



        ),



      ),



    );


  }


}