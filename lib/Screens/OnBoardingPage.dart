import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Screens/Auth/LoginPage.dart';
import 'package:real_estate_quantapixel/Screens/Constants/Colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _textAnimation;

  final String text = "Adshow"; // Text to animate

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      duration: Duration(seconds: 1), // Controls speed of text animation
      vsync: this,
    )..forward();

    // Letter-by-letter animation
    _textAnimation = IntTween(begin: 0, end: text.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Navigate to the next screen after 5 seconds
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 248, 248),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(height: 70, child: Image.asset('assets/1.png')),
            SizedBox(width: 10), // Space between image and text
            AnimatedBuilder(
              animation: _textAnimation,
              builder: (context, child) {
                return Text(
                  text.substring(
                      0, _textAnimation.value), // Reveal letters gradually
                  style: GoogleFonts.poppins(
                      fontSize: 30, fontWeight: FontWeight.bold),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
