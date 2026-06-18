import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isLoading = false;

  Future<void> signInWithGoogle() async {

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {

      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();


      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }


      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;


      final credential =
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );


      final userCredential =
      await FirebaseAuth.instance
          .signInWithCredential(credential);



      final user = userCredential.user!;

      final uid = user.uid;


      print("USER UID: $uid");


      // Check admin collection

      final userDoc = await FirebaseFirestore.instance
          .collection("admins")
          .doc(uid)
          .get();


      print("ADMIN DATA:");
      print(userDoc.data());



      if(userDoc.exists){

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text("Admin Login"),
          ),
        );

      }

      else{

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text("Student Login"),
          ),
        );

      }


    }

    catch(e){

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text("Login failed: $e"),
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


          onPressed:
          isLoading ? null : signInWithGoogle,

        ),

      ),

    );

  }

}