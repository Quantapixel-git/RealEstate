import 'package:flutter/material.dart';
import 'adminhome.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _adminEmailController = TextEditingController();
  final TextEditingController _adminPasswordController = TextEditingController();

  void _adminLogin() {
    final email = _adminEmailController.text;
    final password = _adminPasswordController.text;

    if (email == 'admin@example.com' && password == 'admin123') {
      // Navigate to Admin Home Page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid admin credentials')),
      );
    }
  }

  void _skipLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AdminHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50], // Soft background color for consistency
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0), // Improved padding
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Admin Login',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal, // Consistent teal color for header
                  ),
                ),
                const SizedBox(height: 40),

                // Admin Email TextField with enhanced styling
                TextField(
                  controller: _adminEmailController,
                  decoration: InputDecoration(
                    labelText: 'Admin Email',
                    labelStyle: const TextStyle(color: Colors.teal),
                    hintText: 'Enter admin email',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.teal, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Admin Password TextField with enhanced styling
                TextField(
                  controller: _adminPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Admin Password',
                    labelStyle: const TextStyle(color: Colors.teal),
                    hintText: 'Enter password',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.teal, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                // Login Button with modern design
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal, // Consistent button color
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 5, // Subtle shadow for depth
                    ),
                    onPressed: _adminLogin,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Skip button with consistent styling
                TextButton(
                  onPressed: _skipLogin,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
