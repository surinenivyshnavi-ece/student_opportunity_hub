import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatelessWidget {

  const LoginPage({super.key});


  Future<void> signInWithGoogle(BuildContext context) async {

    try {

      GoogleAuthProvider googleProvider =
      GoogleAuthProvider();


      await FirebaseAuth.instance
          .signInWithPopup(googleProvider);



      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content: Text("Login Successful"),

        ),

      );




    } catch(e) {


      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(
            "Login failed: $e",
          ),

        ),

      );


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

          label: const Text(
            "Sign in with Google",
          ),


          onPressed: () {

            signInWithGoogle(context);

          },


        ),

      ),

    );


  }

}