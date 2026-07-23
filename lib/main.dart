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
import 'bookmarks_page.dart';
import 'app_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'certification_page.dart';
import 'workshops_page.dart';
import 'events_page.dart';
import 'feedback_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'complete_profile_page.dart';
import 'pending_verification_page.dart';
import 'super_admin_dashboard.dart';
import 'college_admin_home_page.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );


  runApp(const MyApp());
}





class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    requestPermission();
    setupForegroundNotifications();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      print("Notification Clicked");
      print(message.data);

      String? screen = message.data["screen"];

      if (screen == "internship") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const InternshipsPage(),
          ),
        );
      }

      if (screen == "hackathon") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HackathonsPage(),
          ),
        );
      }

      if (screen == "event") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EventsPage(),
          ),
        );
      }

      if (screen == "workshop") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const WorkshopsPage(),
          ),
        );
      }

      if (screen == "certification") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CertificationPage(),
          ),
        );
      }


    });
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.subscribeToTopic("allUsers");
    String? token = await FirebaseMessaging.instance.getToken();

    print("FCM Token: $token");

    final user = FirebaseAuth.instance.currentUser;

    if (user != null && token != null) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(
        {
          "fcmToken": token,
        },
        SetOptions(merge: true),
      );
    }
    print("Subscribed to allUsers topic successfully");

  }   // <-- ADD THIS BRACKET

  void setupForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print("Foreground Notification");
      print(message.data);

      String? screen = message.data["screen"];

      if (screen == "internship") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const InternshipsPage(),
          ),
        );
      }

      if (screen == "hackathon") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HackathonsPage(),
          ),
        );
      }

      if (screen == "event") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const EventsPage(),
          ),
        );
      }

      if (screen == "workshop") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const WorkshopsPage(),
          ),
        );
      }

      if (screen == "certification") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CertificationPage(),
          ),
        );
      }

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'student_opportunity_channel',
              'Student Opportunity Notifications',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Opportunity Hub',

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFB5C0A2),

        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),

        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),

      home: AuthCheck(),
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

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }


        if (snapshot.data != null) {

          return FutureBuilder<List<DocumentSnapshot>>(
            future: Future.wait([

              // Student profile check
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(snapshot.data!.uid)
                  .get(),

              // College admin check
              FirebaseFirestore.instance
                  .collection("admins")
                  .doc(snapshot.data!.uid)
                  .get(),

              // Super admin check
              FirebaseFirestore.instance
                  .collection("super_admins")
                  .doc(snapshot.data!.uid)
                  .get(),

            ]),

            builder: (context, userSnapshot) {


              if (!userSnapshot.hasData) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }


              final userDoc =
              userSnapshot.data![0];

              final adminDoc =
              userSnapshot.data![1];

              final superAdminDoc =
              userSnapshot.data![2];


              // 1. Super Admin first
              if (superAdminDoc.exists) {
                return const SuperAdminDashboard();
              }


              // 2. College Admin
              if (adminDoc.exists) {

                final adminData =
                adminDoc.data() as Map<String, dynamic>;


                if (adminData["role"] == "collegeAdmin") {

                  final status =
                      adminData["status"] ?? "active";


                  if (status.toString().trim().toLowerCase() == "inactive") {

                    FirebaseAuth.instance.signOut();

                    return const LoginPage();

                  }


                  return const CollegeAdminHomePage();

                }
              }

              // 3. Student
              if (!userDoc.exists) {
                return const CompleteProfilePage();
              }


              final data =
              userDoc.data() as Map<String, dynamic>;


              if (data["profileCompleted"] != true) {
                return const CompleteProfilePage();
              }


              if (data["verified"] != true) {
                return const PendingVerificationPage();
              }


              return const HomePage();

            },
          );

        }


        return const LoginPage();

      },
    );

  }
}






