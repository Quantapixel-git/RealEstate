import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  bool isBottom;

  CustomButton(
      {required this.text, required this.onTap, required this.isBottom});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 60,
        width: MediaQuery.of(context).size.height * 0.88,
        margin:
            EdgeInsets.symmetric(horizontal: 20, vertical: isBottom ? 34 : 5),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
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

  const CustomTextField({
    required this.icon,
    required this.hintText,
    required this.isPassword,
    required this.controller,
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
      child: TextField(
        controller: controller, // Assign the controller
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon:
              isPassword ? Icon(Icons.visibility, color: Colors.grey) : null,
        ),
      ),
    );
  }
}

class CustomTextFieldSignup extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  String? Function(String?)? validator;
  TextInputType keyboardType;

  CustomTextFieldSignup({
    required this.validator,
    required this.keyboardType,
    required this.icon,
    required this.hintText,
    required this.isPassword,
    required this.controller,
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
        validator: validator,
        keyboardType: keyboardType,
        controller: controller, // Assign the controller
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon:
              isPassword ? Icon(Icons.visibility, color: Colors.grey) : null,
        ),
      ),
    );
  }
}
