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
  Future<void> openLink(String link) async {
    final Uri url = Uri.parse(link);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
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

            Text("Organization: $organization"),

            const SizedBox(height: 10),

            Text("Deadline: $deadline"),

            const SizedBox(height: 15),

            Text(description),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                openLink(link);
              },

              child: const Text("Apply Now"),
            ),
          ],
        ),
      ),
    );
  }
}