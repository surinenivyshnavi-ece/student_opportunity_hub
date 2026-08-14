import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';

class MyApplicationsPage extends StatelessWidget {
  const MyApplicationsPage({super.key});

  Future<void> openLink(
      BuildContext context,
      String link,
      ) async {
    try {
      final Uri url = Uri.parse(link);

      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not open the link"),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not open link: $e"),
          ),
        );
      }
    }

  }

  Future<void> deleteApplication(
      BuildContext context,
      String applicationId,
      ) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Remove Application"),
          content: const Text(
            "Are you sure you want to remove this application "
                "from My Applications?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text("Remove"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('applications')
          .doc(applicationId)
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Application removed"),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not remove application: $e"),
          ),
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

// User is not logged in
    if (user == null) {
      return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text("My Applications"),
            ),
        body: const Center(
          child: Text(
            "Please login to view your applications.",
            style: TextStyle(fontSize: 16),
          ),
        ),
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Applications"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('applications')
            .orderBy('appliedAt', descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Error loading applications:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // No applications
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.assignment_outlined,
                      size: 80,
                      color: Colors.indigo,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "No Applications Yet",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Your applied hackathons and events "
                          "will appear here.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final applications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final document = applications[index];

              final data =
              document.data() as Map<String, dynamic>;

              final String title =
                  data['title']?.toString() ??
                      'Untitled Opportunity';

              final String type =
                  data['type']?.toString() ??
                      'Opportunity';

              final String organizer =
                  data['organizer']?.toString() ??
                      'Unknown Organizer';

              final String date =
                  data['date']?.toString() ?? '';

              final String deadline =
                  data['deadline']?.toString() ?? '';

              final String link =
                  data['link']?.toString() ?? '';

              final String status =
                  data['status']?.toString() ?? 'Applied';

              return Card(
                margin: const EdgeInsets.only(bottom: 18),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(18),

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      // Title
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding:
                            const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade50,
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.assignment_turned_in,
                              color: Colors.indigo,
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Type
                      Row(
                        children: [
                          const Icon(
                            Icons.category_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Type: $type",
                              style:
                              const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Organizer
                      Row(
                        children: [
                          const Icon(
                            Icons.business_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Organizer: $organizer",
                              style:
                              const TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Date
                      if (date.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Date: $date",
                                style:
                                const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Deadline
                      if (deadline.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 20,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Deadline: $deadline",
                                style:
                                const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      const SizedBox(height: 15),

                      // Status
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 18,
                              color:
                              Colors.green.shade800,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              status,
                              style: TextStyle(
                                color:
                                Colors.green.shade800,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Buttons
                      Row(
                        children: [

                          // View Opportunity
                          if (link.isNotEmpty)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  openLink(
                                    context,
                                    link,
                                  );
                                },
                                icon: const Icon(
                                  Icons.open_in_new,
                                ),
                                label: const Text(
                                  "View",
                                ),
                              ),
                            ),

                          if (link.isNotEmpty)
                            const SizedBox(width: 10),

                          // Remove
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                deleteApplication(
                                  context,
                                  document.id,
                                );
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                              ),
                              label: const Text(
                                "Remove",
                              ),
                              style:
                              OutlinedButton.styleFrom(
                                foregroundColor:
                                Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );

  }
}