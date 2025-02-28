import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> submitForm() async {
    if (_formKey.currentState!.validate()) {
      final url =
          Uri.parse("https://adshow.in/app/api/storeContact");
      final Map<String, String> body = {
        "name": nameController.text,
        "mobile": phoneController.text,
        "email": emailController.text,
        "message": messageController.text,
      };

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );

        if (response.statusCode == 201) {
          _showSnackbar("Message sent successfully!", Colors.green);
          nameController.clear();
          phoneController.clear();
          emailController.clear();
          messageController.clear();
        } else {
          _showSnackbar("Failed to send message. Try again!", Colors.red);
        }
      } catch (error) {
        _showSnackbar("Error: $error", Colors.red);
      }
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Contact Us",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        // centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Name", Icons.person, nameController,
                    "Please enter your name"),
                SizedBox(height: 10),
                _buildTextField("Phone Number", Icons.phone, phoneController,
                    "Please enter your phone number"),
                SizedBox(height: 10),
                _buildTextField(
                    "Email ", Icons.email, emailController, null),
                SizedBox(height: 10),
                _buildTextField("Message", Icons.message, messageController,
                    "Please enter your message",
                    maxLines: 4),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submitForm,
                    child: Text("Submit",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: Colors.blue.shade900,
                      elevation: 3,
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

  Widget _buildTextField(String label, IconData icon,
      TextEditingController controller, String? validationMsg,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.blue.shade900),
            hintText: "Enter $label",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: validationMsg != null
              ? (value) => value!.isEmpty ? validationMsg : null
              : null,
        ),
      ],
    );
  }
}
