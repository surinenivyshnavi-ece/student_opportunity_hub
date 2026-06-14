import 'package:flutter/material.dart';

class InternshipsPage extends StatelessWidget {
  const InternshipsPage({super.key});

  final List<Map<String, String>> internships = const [
    {
      "company": "Google",
      "role": "SDE Intern",
      "duration": "2 Months",
      "type": "Remote"
    },
    {
      "company": "Infosys",
      "role": "Web Developer Intern",
      "duration": "3 Months",
      "type": "Hybrid"
    },
    {
      "company": "TCS",
      "role": "Embedded Systems Intern",
      "duration": "6 Weeks",
      "type": "On-site"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Internships")),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: internships.length,
        itemBuilder: (context, index) {
          final item = internships[index];

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["company"]!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  Text("Role: ${item["role"]}"),
                  Text("Duration: ${item["duration"]}"),
                  Text("Type: ${item["type"]}"),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Applied Successfully!")),
                        );
                      },
                      child: const Text("Apply"),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


