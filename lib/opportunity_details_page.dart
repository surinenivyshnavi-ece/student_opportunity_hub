import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OpportunityDetailsPage extends StatelessWidget {
  final String title;
  final String organization;
  final String deadline;
  final String description;
  final String link;

  const OpportunityDetailsPage({
    super.key,
    required this.title,
    required this.organization,
    required this.deadline,
    required this.description,
    required this.link,
  });

  Future<void> openLink(BuildContext context, String link) async {
    try {
      final Uri url = Uri.parse(link);

      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Could not open link: $e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Opportunity Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              "Organization: $organization",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            Text(
              "Deadline: $deadline",
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 15),

            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print("Link = $link");

                  if (link.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("No application link available"),
                      ),
                    );
                    return;
                  }

                  openLink(context, link);
                },
                child: const Text("Apply Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}