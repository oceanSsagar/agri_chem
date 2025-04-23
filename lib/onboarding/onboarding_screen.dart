import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agri_chem/screens/main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _phoneNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController(); // Add this

  final _usernameController = TextEditingController(); // For custom username
  String _gender = "Male";
  String _userType = "Farmer";
  String _languagePreference = "English";

  // Function to check if username exists in Firestore
  Future<bool> _isUsernameTaken(String username) async {
    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('agri_users')
            .where('username', isEqualTo: username)
            .get();

    return querySnapshot
        .docs
        .isNotEmpty; // Return true if the username is taken
  }

  Future<void> _saveUserData(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No authenticated user found.");

      final username = _usernameController.text.trim();
      if (username.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username cannot be empty.")),
        );
        return;
      }

      // Check for unique username
      final usernameTaken = await _isUsernameTaken(username);
      if (usernameTaken) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Username is already taken, please choose another one.",
            ),
          ),
        );
        return;
      }

      final userData = {
        'uid': user.uid,
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'username': username,
        'gender': _gender,
        'userType': _userType,
        'languagePreference': _languagePreference,
        'avatarUrl':
            "https://firebasestorage.googleapis.com/v0/b/interns25-saffronedge-samarth.firebasestorage.app/o/agrichem%2Fimages%2Favatar%2Fdefault_avatar.png?alt=media&token=f55da4c2-d273-4154-a27b-d81081d5b10e",
        'profileCompleted': true,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('agri_users')
          .doc(user.uid)
          .set(userData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile created successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error saving user data: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user?.email != null) {
      _emailController.text = user!.email!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF7EC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Agri Chem!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF388E3C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please tell us a bit about yourself.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 25),

                  // First name, last name, phone fields
                  _buildTextField(
                    "First Name",
                    _firstNameController,
                    Icons.person,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    "Last Name",
                    _lastNameController,
                    Icons.person_outline,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    "Phone Number",
                    _phoneNumberController,
                    Icons.phone,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    "Email Address",
                    _emailController,
                    Icons.email,
                  ),

                  const SizedBox(height: 20),

                  // Username input field
                  _buildTextField(
                    "Username",
                    _usernameController,
                    Icons.person_add,
                  ),

                  const SizedBox(height: 20),
                  _buildDropdown("Gender", _gender, ["Male", "Female"], (val) {
                    setState(() => _gender = val!);
                  }),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    "User Type",
                    _userType,
                    ["Farmer", "Student"],
                    (val) {
                      setState(() => _userType = val!);
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    "Language",
                    _languagePreference,
                    ["English", "Marathi", "Hindi"],
                    (val) {
                      setState(() => _languagePreference = val!);
                    },
                  ),

                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _saveUserData(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items:
              items
                  .map(
                    (e) => DropdownMenuItem<String>(value: e, child: Text(e)),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
