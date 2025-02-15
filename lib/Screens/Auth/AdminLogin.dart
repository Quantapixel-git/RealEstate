import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Screens/Admin/adminHome.dart';
import 'package:real_estate_quantapixel/Screens/Admin/homeadmin.dart';
import 'package:real_estate_quantapixel/Screens/Auth/LoginPage.dart';
import 'package:real_estate_quantapixel/Screens/Constants/Colors.dart';
import 'package:real_estate_quantapixel/Screens/shared_pref.dart';

class Adminlogin extends StatefulWidget {
  @override
  State<Adminlogin> createState() => _AdminloginState();
}

class _AdminloginState extends State<Adminlogin> {
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _validateAndLogin() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == 'admin@gmail.com' &&
          _passwordController.text == 'admin') {
        SharedPref().setAdminLogin(true);
        print(SharedPref().isAdminLoggedIn());

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Email and Password')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide valid credentials')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8F8), // Light green background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Assign the form key here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                InkWell(
                  onLongPress: () {},
                  child: Container(
                      height: 204,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Image.asset('assets/1.png')),
                ),
                SizedBox(height: 20),
                Text(
                  'Admin Login',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  icon: Icons.email,
                  hintText: 'Email Address',
                  isPassword: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    // Simple email validation
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null; // Return null if validation passes
                  },
                ),
                SizedBox(height: 15),
                CustomTextField(
                  controller: _passwordController,
                  icon: Icons.lock,
                  hintText: 'Password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null; // Return null if validation passes
                  },
                ),
                SizedBox(height: 10),
                SizedBox(height: 20),
                _buildButton(
                    'Login', Colors.black, Colors.white, _validateAndLogin),
                SizedBox(height: 10),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
      String text, Color bgColor, Color textColor, VoidCallback onPressed,
      {bool isOutlined = false}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : bgColor,
          side: isOutlined ? BorderSide(color: Colors.black) : BorderSide.none,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  CustomTextField({
    required this.icon,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          blurRadius: 8,
          spreadRadius: 0,
          color: const Color.fromARGB(255, 248, 221, 221),
        )
      ]),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isPassword,
        keyboardType: isPassword
            ? TextInputType.visiblePassword
            : TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.black),
          prefixIcon: Icon(icon, color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
