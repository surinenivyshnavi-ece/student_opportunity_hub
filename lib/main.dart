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
  }

  Future<void> requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.subscribeToTopic("allUsers");

    print("Subscribed to allUsers topic successfully");
  }
  void setupForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
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
        scaffoldBackgroundColor: const Color(0xffF5F7FA),

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

      //drawer: const AppDrawer(),

      backgroundColor: const Color(0xFF9EB294),


      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Student Opportunity Hub",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        leading: PopupMenuButton<String>(
          icon: const Icon(
            Icons.account_circle,
            size: 30,
            color: Colors.black,
          ),
          onSelected: (value) async {
            if (value == "profile") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(),
                ),
              );
            } else if (value == "settings") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Settings page coming soon"),
                ),
              );
            } else if (value == "logout") {

              bool? confirmLogout = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text(
                      "Are you sure you want to logout?",
                    ),
                    actions: [

                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text("Cancel"),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text("Logout"),
                      ),

                    ],
                  );
                },
              );

              if (confirmLogout == true) {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Logged out successfully"),
                  ),
                );
              }
            }
          },
          itemBuilder: (context) =>
          [
            const PopupMenuItem(
              value: "profile",
              child: Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text("Profile"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: "settings",
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 10),
                  Text("Settings"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: "logout",
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 10),
                  Text("Logout"),
                ],
              ),
            ),
          ],
        ),
      ),


      body: Center(


        child: SingleChildScrollView(


          child: Padding(


            padding: const EdgeInsets.all(20),


            child: Column(


              mainAxisAlignment:
              MainAxisAlignment.center,


              children: [


                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 90,
                  ),
                ),

                const SizedBox(height: 20),


                const Text(
                  "Welcome to\nStudent Opportunity Hub",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),


                const SizedBox(height: 10),


                const Text(
                  "Discover internships, hackathons, jobs, certifications and more—all in one place.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 25,
                  runSpacing: 20,
                  children: [

                    buildHomeCard(
                        context, "Internships", Icons.school, Colors.green,
                        const InternshipsPage()),

                    buildHomeCard(context, "Hackathons", Icons.emoji_events,
                        Colors.orange, const HackathonsPage()),

                    buildHomeCard(context, "Team", Icons.groups, Colors.blue,
                        const TeamFormationPage()),

                    buildHomeCard(
                        context, "Certificates", Icons.workspace_premium,
                        Colors.deepPurple, const CertificationPage()),

                    buildHomeCard(
                        context, "Workshops", Icons.menu_book, Colors.red,
                        const WorkshopsPage()),

                    buildHomeCard(context, "Events", Icons.event, Colors.teal,
                        const EventsPage()),
                  ],
                ),

                const SizedBox(height: 30),

                const Text(
                  "Built by Team Student Opportunity Hub",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),


              ],


            ),


          ),


        ),


      ),


    );
  }

  Widget buildHomeCard(BuildContext context,
      String title,
      IconData icon,
      Color color,
      Widget page,) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 38,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}