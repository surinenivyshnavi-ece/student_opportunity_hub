import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'complete_profile_page.dart';
import 'pending_verification_page.dart';
import 'admin_request_form_page.dart';
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
      final uid = user.uid;
      // Check if the user is an admin
      final adminDoc = await FirebaseFirestore.instance
          .collection("admins")
          .doc(uid)
          .get();


      if (adminDoc.exists) {
        final adminData = adminDoc.data()!;
        print("ADMIN DATA:");
        print(adminData);

        print("ROLE:");
        print(adminData["role"]);

        print("STATUS:");
        print(adminData["status"]);





          if (adminData["role"] == "collegeAdmin") {
            final status = adminData["status"] ?? "active";


            if (status.toString().trim().toLowerCase() == "inactive") {


              await FirebaseAuth.instance.signOut();

              if (context.mounted) {
                setState(() {
                  isDeactivated = true;
                });
              }

              return;




            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const CollegeAdminHomePage(),
              ),
            );


            return;
          }
        }

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

          return; // ADD THIS
        }
        final data = doc.data() as Map<String, dynamic>;


        if (data["profileCompleted"] != true) {
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

        if (data["verified"] != true) {
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const PendingVerificationPage(),
              ),
            );
          }
          return;
        }

        // If profile is completed and verified
        // No navigation needed here because AuthCheck will open HomePage.
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Use the same navigation logic you already have
      // (check admin, profileCompleted, verified)
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login Failed")),
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
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () async {
                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Enter your email first"),
                    ),
                  );
                  return;
                }

                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: emailController.text.trim(),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Password reset email sent"),
                  ),
                );
              },
              child: const Text("Forgot Password?"),
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
}
