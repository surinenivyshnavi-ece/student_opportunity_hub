import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'complete_profile_page.dart';
import 'pending_verification_page.dart';
import 'college_admin_home_page.dart';
import 'super_admin_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isLoading = false;
  bool isDeactivated = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  Future<void> checkUserAfterLogin(User user) async {

    final uid = user.uid;


    // 1. Check Admin
    final adminDoc = await FirebaseFirestore.instance
        .collection("admins")
        .doc(uid)
        .get();


    if (adminDoc.exists) {

      final adminData = adminDoc.data()!;


      if(adminData["role"]=="super_admin"){

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const SuperAdminHomePage(),
          ),
        );

        return;

      }


      if(adminData["role"]=="collegeAdmin"){

        final status = adminData["status"] ?? "active";


        if(status.toString().trim().toLowerCase()=="inactive"){

          await FirebaseAuth.instance.signOut();

          if(context.mounted){
            setState(() {
              isDeactivated=true;
            });
          }

          return;

        }


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const CollegeAdminHomePage(),
          ),
        );

        return;

      }
    }



    // 2. Check Student Profile

    final userRef = FirebaseFirestore.instance
        .collection("users")
        .doc(uid);


    final doc = await userRef.get();



    // New user

    if(!doc.exists){

      await userRef.set({

        "name": user.displayName ?? "",
        "email": user.email ?? "",
        "photoUrl": user.photoURL ?? "",
        "college":"",
        "branch":"",
        "year":"",
        "rollNo":"",
        "phone":"",
        "role":"student",
        "verified":false,
        "status":"pending",
        "profileCompleted":false,
        "createdAt":FieldValue.serverTimestamp(),

      });


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CompleteProfilePage(),
        ),
      );


      return;
    }



    final data = doc.data()!;



    // 3. Check profile completed

    if(data["profileCompleted"] != true){

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const CompleteProfilePage(),
        ),
      );

      return;
    }




    // 4. Check verification

    if(data["verified"] != true){

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const PendingVerificationPage(),
        ),
      );

      return;
    }



    // 5. Verified user

    // AuthCheck will open HomePage


  }

  Future<void> signInWithGoogle() async {

    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      await GoogleSignIn().signOut();

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


      await checkUserAfterLogin(user);


      return;
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

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

    }

  }
  Future<void> signInWithEmail() async {

    try {

final userCredential =
await FirebaseAuth.instance.signInWithEmailAndPassword(
email: emailController.text.trim(),
password: passwordController.text.trim(),
);


final user = userCredential.user!;


await checkUserAfterLogin(user);


      // Add your same navigation logic here:
      // Admin check
      // Profile completed check
      // Verification check


    } on FirebaseAuthException catch (e) {


      String message = "Login failed";


      if (e.code == "user-not-found") {

        message = "No account found with this email";

      }
      else if (e.code == "wrong-password") {

        message = "Incorrect password";

      }
      else if (e.code == "invalid-email") {

        message = "Invalid email format";

      }


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
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
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          if (isDeactivated)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Your admin account has been deactivated",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
            ),

          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: passwordController,
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: "Password",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ),
          ),


          const SizedBox(height: 20),

          // Password TextField will come here next

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: signInWithEmail,
              child: const Text("Login"),
            ),
          ),

          const SizedBox(height: 20),

          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("OR"),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 20),

          ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: isLoading
                ? const Text("Signing in...")
                : const Text("Continue with Google"),
            onPressed: isLoading ? null : signInWithGoogle,
          ),

        ],
      ),
    ),
  );
}
@override
void dispose(){

emailController.dispose();
passwordController.dispose();

super.dispose();

}

}
