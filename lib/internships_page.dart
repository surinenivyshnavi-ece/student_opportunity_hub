import 'package:flutter/material.dart';

class InternshipsPage extends StatelessWidget {
  const InternshipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Internships")),
      body: const Center(
        child: Text(
          "Internship Listings Coming Soon",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}





