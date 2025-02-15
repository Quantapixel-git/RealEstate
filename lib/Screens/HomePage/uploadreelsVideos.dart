import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

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
  File? videoFile;
  File? imageFile;
  bool isUploading = false;

  final picker = ImagePicker();

  Future<void> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        videoFile = File(pickedFile.path);
      });
      print("Video selected: ${videoFile!.path}"); // Debugging
    } else {
      print("No video selected");
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      print("Image selected: ${imageFile!.path}"); // Debugging
    } else {
      print("No image selected");
    }
  }

  Future<void> uploadProperty() async {
    if (videoFile == null || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a video and an image")),
      );
      return;
    }

    try {
      setState(() {
        isUploading = true;
      });

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://quantapixel.in/realestate/api/storeProperty'),
      );

      request.fields['user_id'] = '75';
      request.fields['type'] = 'reel';
      request.fields['name'] = nameController.text;
      request.fields['location'] = locationController.text;
      request.fields['price'] = priceController.text;
      request.fields['description'] = descriptionController.text;
      request.fields['mobile'] = mobileController.text;
      request.fields['amenities'] = 'Amenities sample';

      // 🛠 Check if file paths are valid
      if (videoFile!.path.isEmpty || imageFile!.path.isEmpty) {
        print("Error: One or more file paths are empty");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File paths are invalid")),
        );
        return;
      }

      request.files.add(
        await http.MultipartFile.fromPath('video', videoFile!.path),
      );

      request.files.add(
        await http.MultipartFile.fromPath('thumbnail', imageFile!.path),
      );

      var response = await request.send();
      print("Response status: ${response.statusCode}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Property uploaded successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed. Please try again.")),
        );
      }
    } catch (e) {
      print("Upload error: $e"); // Log errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Property", style: GoogleFonts.poppins()),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Property Name'),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: mobileController,
                decoration: InputDecoration(labelText: 'Mobile'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: Text("Select Thumbnail"),
              ),
              imageFile != null
                  ? Image.file(imageFile!, height: 100)
                  : Text("No image selected",
                      style: TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: pickVideo,
                child: Text("Select Video"),
              ),
              videoFile != null
                  ? Text("Video selected",
                      style: TextStyle(color: Colors.green))
                  : Text("No video selected",
                      style: TextStyle(color: Colors.red)),
              SizedBox(height: 10),
              isUploading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: uploadProperty,
                      child: Text("Upload Property"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
