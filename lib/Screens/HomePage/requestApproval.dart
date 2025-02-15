import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false; // Loading state

  // Controllers for text fields
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController stateController = TextEditingController();

  // Image Picker Function
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Show Snackbar
  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Submit API Function
  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    var url =
        Uri.parse("https://quantapixel.in/realestate/api/profileActivation");
    var request = http.MultipartRequest("POST", url);

    request.fields['user_id'] = '78'; // Static user ID
    request.fields['whatsapp'] = whatsappController.text;
    request.fields['email'] = emailController.text;
    request.fields['gender'] = genderController.text;
    request.fields['bio'] = bioController.text;
    request.fields['dob'] = dobController.text;
    request.fields['street'] = streetController.text;
    request.fields['city'] = cityController.text;
    request.fields['district'] = districtController.text;
    request.fields['state'] = stateController.text;

    // Attach image if selected
    if (_image != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", _image!.path),
      );
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(responseBody);
        _showSnackbar(decodedData["message"]);
      } else {
        _showSnackbar("Error: ${response.reasonPhrase}", isError: true);
      }
    } catch (e) {
      _showSnackbar("⚠️ Exception: $e", isError: true);
    }

    setState(() {
      _isLoading = false;
    });
  }

  // Text Field Widget
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 14),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
        ),
        validator: (value) => value!.isEmpty ? "$label is required" : null,
      ),
    );
  }

  // Image Picker Widget
  Widget _buildImagePicker() {
    return Column(
      children: [
        if (_image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child:
                Image.file(_image!, height: 100, width: 100, fit: BoxFit.cover),
          ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.upload, color: Colors.white),
          label: Text("Upload Image", style: GoogleFonts.poppins()),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width; // For responsiveness

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "User Information Form",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("WhatsApp", whatsappController),
                _buildTextField("Email", emailController),
                _buildTextField("Gender", genderController),
                _buildTextField("Bio", bioController),
                _buildImagePicker(),
                _buildTextField("Date of Birth", dobController),
                _buildTextField("Street", streetController),
                _buildTextField("City", cityController),
                _buildTextField("District", districtController),
                _buildTextField("State", stateController),
                const SizedBox(height: 20),

                // Submit Button with Loader
                SizedBox(
                  width: width,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : submitForm,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Submit",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
