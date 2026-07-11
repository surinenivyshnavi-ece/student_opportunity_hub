import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'complete_profile_page.dart';

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
      await FirebaseAuth.instance.signInWithCredential(credential);

      final user = userCredential.user!;
      final uid = user.uid;

      final userRef = FirebaseFirestore.instance
          .collection("users")
          .doc(uid);

      final doc = await userRef.get();
      print("================================");
      print("UID: $uid");
      print("Document exists: ${doc.exists}");
      print(doc.data());
      print("================================");

      if (!doc.exists) {
        print("New user - Opening Complete Profile");

        await userRef.set({
          "name": user.displayName ?? "",
          "email": user.email ?? "",
          "photoUrl": user.photoURL ?? "",
          "college": "",
          "branch": "",
          "year": "",
          "rollNo": "",
          "phone": "",
          "role": "student",
          "verified": false,
          "status": "pending",
          "profileCompleted": false,
          "createdAt": FieldValue.serverTimestamp(),
        });

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const CompleteProfilePage(),
            ),
          );
        }

        return;   // ADD THIS
      }


// Existing users check
      final data = doc.data() as Map<String, dynamic>;

      if (data["profileCompleted"] != true) {

        print("Profile not completed - Opening Complete Profile");

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const CompleteProfilePage(),
            ),
          );
        }

        return;
      }

      print("Profile completed - Continue to Home");


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