import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPropertyScreen extends StatefulWidget {
  @override
  _UploadPropertyScreenState createState() => _UploadPropertyScreenState();
}

class _UploadPropertyScreenState extends State<UploadPropertyScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController amenitiesController = TextEditingController();

  File? videoFile;
  File? imageFile;
  bool isUploading = false;
  String selectedType = 'reel';
  final picker = ImagePicker();

  Future<void> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      File selectedVideo = File(pickedFile.path);
      setState(() {
        videoFile = selectedVideo;
      });
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> uploadProperty() async {
    if (videoFile == null || imageFile == null) {
      _showSnackbar("Please select a video and an image", Colors.red);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');
    if (userId == null) {
      _showSnackbar("User  ID not found", Colors.red);
      return;
    }

    try {
      setState(() {
        isUploading = true;
      });

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://adshow.in/app/api/storeProperty'),
      );

      request.fields['user_id'] = userId.toString();
      request.fields['type'] = selectedType;
      request.fields['name'] = nameController.text;
      request.fields['location'] = locationController.text;
      request.fields['price'] = priceController.text;
      request.fields['description'] = descriptionController.text;
      request.fields['mobile'] = mobileController.text;
      request.fields['amenities'] = amenitiesController.text;

      request.files.add(
        await http.MultipartFile.fromPath('video', videoFile!.path),
      );
      request.files.add(
        await http.MultipartFile.fromPath('thumbnail', imageFile!.path),
      );

      var response = await request.send();

      if (response.statusCode == 201) {
        _showSnackbar("Property uploaded successfully!", Colors.green);

        // Clear the fields after successful submission
        nameController.clear();
        locationController.clear();
        priceController.clear();
        descriptionController.clear();
        mobileController.clear();
        amenitiesController.clear();
        setState(() {
          videoFile = null; // Clear the video file
          imageFile = null; // Clear the image file
          selectedType = 'reel'; // Reset to default type if needed
        });
      } else {
        _showSnackbar("Upload failed. Please try again.", Colors.red);
      }
    } catch (e) {
      _showSnackbar("An error occurred: $e", Colors.red);
    } finally {
      setState(() {
        isUploading = false;
      });
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
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Upload Property",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            // centerTitle: true,
            backgroundColor: Colors.blue.shade900,
            elevation: 4,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("Property Name", Icons.home, nameController),
                  _buildTextField(
                      "Location", Icons.location_on, locationController),
                  _buildTextField("Price", Icons.attach_money, priceController,
                      TextInputType.number),
                  _buildTextField(
                      "Description", Icons.description, descriptionController),
                  _buildTextField("Mobile", Icons.phone, mobileController,
                      TextInputType.phone),
                  _buildTextField(
                      "Amenities", Icons.local_offer, amenitiesController),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedType,
                    items: ['reel', 'video'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.poppins()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedType = newValue!;
                      });
                    },
                    decoration: InputDecoration(labelText: "Select Type"),
                  ),
                  SizedBox(height: 10),
                  _buildFilePickerButton("Select Thumbnail", pickImage),
                  SizedBox(
                    height: 10,
                  ),
                  _buildFilePickerButton("Select Video", pickVideo),
                  SizedBox(height: 10),
                  _buildUploadButton(),
                ],
              ),
            ),
          ),
        ),
        if (isUploading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue.shade900),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFilePickerButton(String text, VoidCallback onPressed) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade900,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Set border radius here
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: uploadProperty,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade900,
          padding: EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text("Upload Property",
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}
