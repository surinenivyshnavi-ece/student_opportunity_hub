import 'package:flutter/material.dart';

class SuperAdminHomePage extends StatelessWidget {
  const SuperAdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Super Admin"),
      ),
      body: const Center(
        child: Text(
          "Super Admin Dashboard",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}