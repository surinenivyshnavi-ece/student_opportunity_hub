import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CollegeAdminProfilePage extends StatefulWidget {
  const CollegeAdminProfilePage({super.key});

  @override
  State<CollegeAdminProfilePage> createState() =>
      _CollegeAdminProfilePageState();
}

class _CollegeAdminProfilePageState
    extends State<CollegeAdminProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _designationController =
  TextEditingController();

  final TextEditingController _collegeNameController =
  TextEditingController();
  final TextEditingController _collegeCodeController =
  TextEditingController();
  final TextEditingController _universityController =
  TextEditingController();
  final TextEditingController _locationController =
  TextEditingController();
  final TextEditingController _websiteController =
  TextEditingController();

  String _email = '';
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ------------------------------------------------------------
  // LOAD PROFILE
  // ------------------------------------------------------------

  Future<void> _loadProfile() async {
    try {
      final User? user = _auth.currentUser;

      if (user == null) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      _email = user.email ?? '';

      final DocumentSnapshot<Map<String, dynamic>> doc =
      await _firestore
          .collection('collegeAdmins')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data() ?? {};

        _nameController.text = data['name'] ?? '';
        _phoneController.text = data['phone'] ?? '';
        _designationController.text =
            data['designation'] ?? 'College Administrator';

        _collegeNameController.text = data['collegeName'] ?? '';
        _collegeCodeController.text = data['collegeCode'] ?? '';
        _universityController.text = data['university'] ?? '';
        _locationController.text = data['location'] ?? '';
        _websiteController.text = data['website'] ?? '';

        _verified = data['verified'] ?? false;
      } else {
        // If Firestore document doesn't exist,
        // use Firebase Authentication information.
        _nameController.text = user.displayName ?? '';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  // SAVE PROFILE
  // ------------------------------------------------------------

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final User? user = _auth.currentUser;

    if (user == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _firestore
          .collection('collegeAdmins')
          .doc(user.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _email,
        'phone': _phoneController.text.trim(),
        'designation': _designationController.text.trim(),
        'collegeName': _collegeNameController.text.trim(),
        'collegeCode': _collegeCodeController.text.trim(),
        'university': _universityController.text.trim(),
        'location': _locationController.text.trim(),
        'website': _websiteController.text.trim(),
        'verified': _verified,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  // ------------------------------------------------------------
  // LOGOUT
  // ------------------------------------------------------------

  Future<void> _logout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text(
            'Are you sure you want to logout?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirm != true) {
      return;
    }

    await _auth.signOut();

    if (!mounted) return;

    // Go back to the login screen.
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
          (route) => false,
    );
  }

  // ------------------------------------------------------------
  // TEXT FIELD
  // ------------------------------------------------------------

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled && _isEditing,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
        ),
        validator: (value) {
          if (label == 'Name' ||
              label == 'College Name') {
            if (value == null || value.trim().isEmpty) {
              return '$label is required';
            }
          }

          return null;
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION TITLE
  // ------------------------------------------------------------

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 16,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PROFILE HEADER
  // ------------------------------------------------------------

  Widget _buildProfileHeader() {
    final String name = _nameController.text.trim();

    String initial = 'A';

    if (name.isNotEmpty) {
      initial = name[0].toUpperCase();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1565C0),
            Color(0xFF42A5F5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white,
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            name.isEmpty ? 'College Administrator' : name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            _designationController.text.isEmpty
                ? 'College Administrator'
                : _designationController.text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email_outlined,
                color: Colors.white70,
                size: 18,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  _email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          if (_verified) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    size: 17,
                    color: Colors.green,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Verified Admin',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: _isEditing ? 'Cancel' : 'Edit Profile',
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit,
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),

      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              // PROFILE HEADER
              _buildProfileHeader(),

              const SizedBox(height: 25),

              // ADMIN INFORMATION
              _sectionTitle(
                'Admin Information',
                Icons.person_outline,
              ),

              _buildTextField(
                label: 'Name',
                controller: _nameController,
                icon: Icons.person,
              ),

              _buildTextField(
                label: 'Email',
                controller:
                TextEditingController(text: _email),
                icon: Icons.email,
                enabled: false,
                keyboardType:
                TextInputType.emailAddress,
              ),

              _buildTextField(
                label: 'Phone',
                controller: _phoneController,
                icon: Icons.phone,
                keyboardType:
                TextInputType.phone,
              ),

              _buildTextField(
                label: 'Designation',
                controller:
                _designationController,
                icon: Icons.badge_outlined,
              ),

              const SizedBox(height: 10),

              // COLLEGE INFORMATION
              _sectionTitle(
                'College Information',
                Icons.school_outlined,
              ),

              _buildTextField(
                label: 'College Name',
                controller:
                _collegeNameController,
                icon: Icons.school,
              ),

              _buildTextField(
                label: 'College Code',
                controller:
                _collegeCodeController,
                icon: Icons.confirmation_number_outlined,
              ),

              _buildTextField(
                label: 'University',
                controller:
                _universityController,
                icon: Icons.account_balance,
              ),

              _buildTextField(
                label: 'Location',
                controller:
                _locationController,
                icon: Icons.location_on_outlined,
              ),

              _buildTextField(
                label: 'Website',
                controller:
                _websiteController,
                icon: Icons.language,
                keyboardType:
                TextInputType.url,
              ),

              // SAVE BUTTON
              if (_isEditing) ...[
                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed:
                    _isSaving
                        ? null
                        : _saveProfile,
                    icon: _isSaving
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Icon(
                      Icons.save,
                    ),
                    label: Text(
                      _isSaving
                          ? 'Saving...'
                          : 'Save Changes',
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 30),

              // LOGOUT
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _designationController.dispose();
    _collegeNameController.dispose();
    _collegeCodeController.dispose();
    _universityController.dispose();
    _locationController.dispose();
    _websiteController.dispose();

    super.dispose();
  }
}