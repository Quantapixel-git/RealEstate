import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_quantapixel/Auth/LoginPage.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  TextEditingController Namecontroller = TextEditingController();
  TextEditingController phonenumcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false; // Loading indicator state
  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill in all required fields correctly.')),
      );
      return;
    }

    setState(() {
      isLoading = true; // Show the loading indicator
    });

    const String url = 'https://quantapixel.in/realestate/api/register';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": Namecontroller.text.trim(),
          "mobile": phonenumcontroller.text.trim(),
          "password": passwordcontroller.text,
          "password_confirmation": confirmpasswordcontroller.text,
        }),
      );

      setState(() {
        isLoading = false; // Hide the loading indicator
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(data['message'] ??
                  'Registration successful! Welcome aboard.')),
        );

        await Future.delayed(const Duration(seconds: 1)); // Delay for Snackbar
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      } else {
        final errorMessage =
            data['message'] ?? 'Something went wrong. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Hide the loading indicator
      });

      String errorMsg =
          'An unexpected error occurred. Please check your internet connection and try again.';
      if (e.toString().contains('SocketException')) {
        errorMsg =
            'No internet connection. Please check your network settings.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMsg = 'Request timed out. Please try again later.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 248, 248), // Light background
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Image.asset('assets/1.png'),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sign Up',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Please enter your details and get started.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20),
                  CustomTextFieldSignup(
                    controller: Namecontroller,
                    keyboardType: TextInputType.name,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your name' : null,
                    icon: Icons.person,
                    hintText: 'Name',
                    isPassword: false,
                  ),
                  SizedBox(height: 15),
                  CustomTextFieldSignup(
                    controller: phonenumcontroller,
                    keyboardType: TextInputType.phone,
                    validator: (value) => value!.isEmpty
                        ? 'Please enter your mobile number'
                        : null,
                    icon: Icons.phone,
                    hintText: 'Mobile Number',
                    isPassword: false,
                  ),
                  SizedBox(height: 15),
                  CustomTextFieldSignup(
                    controller: passwordcontroller,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                    icon: Icons.lock,
                    hintText: 'New Password',
                    isPassword: true,
                  ),
                  SizedBox(height: 15),
                  CustomTextFieldSignup(
                    controller: confirmpasswordcontroller,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordcontroller.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    icon: Icons.lock,
                    hintText: 'Confirm New Password',
                    isPassword: true,
                  ),
                  SizedBox(height: 10),
                  TermsCheckbox(),
                  SizedBox(height: 20),
                  _buildButton('Continue', Colors.black, Colors.white),
                  if (isLoading) ...[
                    SizedBox(height: 20),
                    CircularProgressIndicator(), // Show loading indicator
                  ],
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: "Have an account? "),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
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

  Widget _buildButton(String text, Color bgColor, Color textColor,
      {bool isOutlined = false}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: _registerUser,
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

class TermsCheckbox extends StatefulWidget {
  const TermsCheckbox({super.key});

  @override
  _TermsCheckboxState createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [],
    );
  }
}

class CustomTextFieldSignup extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  CustomTextFieldSignup({
    required this.icon,
    required this.hintText,
    required this.isPassword,
    required this.controller,
    required this.keyboardType,
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
        keyboardType: keyboardType,
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
