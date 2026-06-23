import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final aboutMeController = TextEditingController();
  final collegeController = TextEditingController();
  final branchController = TextEditingController();
  final yearController = TextEditingController();
  final careerGoalController = TextEditingController();
  final cityController = TextEditingController();
  final githubLinkController = TextEditingController();
  final linkedInLinkController = TextEditingController();
  final profilePhotoUrlController = TextEditingController();
  final skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc('user_profile')
          .get();

      if (!doc.exists) return;

      final data = doc.data()!;

      nameController.text = data['name'] ?? '';
      aboutMeController.text = data['aboutMe'] ?? '';
      collegeController.text = data['college'] ?? '';
      branchController.text = data['branch'] ?? '';
      yearController.text = data['year'] ?? '';
      careerGoalController.text = data['careerGoal'] ?? '';
      cityController.text = data['city'] ?? '';
      githubLinkController.text = data['githubLink'] ?? '';
      linkedInLinkController.text = data['linkedInLink'] ?? '';
      profilePhotoUrlController.text =
          data['profilePhotoUrl'] ?? '';

      if (data['skills'] != null) {
        skillsController.text =
            (data['skills'] as List).join(', ');
      }

      setState(() {});
    } catch (e) {
      debugPrint("Load Profile Error: $e");
    }
  }

  Future<void> updateProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc('user_profile')
          .set({
        'name': nameController.text.trim(),
        'aboutMe': aboutMeController.text.trim(),
        'college': collegeController.text.trim(),
        'branch': branchController.text.trim(),
        'year': yearController.text.trim(),
        'careerGoal': careerGoalController.text.trim(),
        'city': cityController.text.trim(),
        'githubLink': githubLinkController.text.trim(),
        'linkedInLink': linkedInLinkController.text.trim(),
        'profilePhotoUrl':
        profilePhotoUrlController.text.trim(),
        'skills': skillsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Profile updated successfully",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error: $e",
          ),
        ),
      );
    }
  }

  Widget buildTextField(
      TextEditingController controller,
      String label, {
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    aboutMeController.dispose();
    collegeController.dispose();
    branchController.dispose();
    yearController.dispose();
    careerGoalController.dispose();
    cityController.dispose();
    githubLinkController.dispose();
    linkedInLinkController.dispose();
    profilePhotoUrlController.dispose();
    skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(
              nameController,
              "Name",
            ),

            buildTextField(
              aboutMeController,
              "About Me",
              maxLines: 3,
            ),

            buildTextField(
              collegeController,
              "College",
            ),

            buildTextField(
              branchController,
              "Branch",
            ),

            buildTextField(
              yearController,
              "Year",
            ),

            buildTextField(
              careerGoalController,
              "Career Goal",
            ),

            buildTextField(
              cityController,
              "City",
            ),

            buildTextField(
              githubLinkController,
              "GitHub Link",
            ),

            buildTextField(
              linkedInLinkController,
              "LinkedIn Link",
            ),

            buildTextField(
              profilePhotoUrlController,
              "Profile Photo URL",
            ),

            buildTextField(
              skillsController,
              "Skills (comma separated)",
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: updateProfile,
                child: const Text(
                  "Save Profile",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}