import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Screens/Constants/BlackContainer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 248, 248), // Light green background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: 150,
                    width: 150,
                    child: Center(child: Image.asset('assets/1.png')),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Forgot Password?',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please enter your email address to receive a 4-digit verification code.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    controller: emailcontroller,
                    icon: Icons.email,
                    hintText: 'Email Address',
                    isPassword: false,
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                      isBottom: false,
                      text: 'Submit',
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back to login',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: 'Create an account',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
