import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditPropertyForm extends StatefulWidget {
  final Map<String, dynamic> propertyData;

  const EditPropertyForm({Key? key, required this.propertyData})
      : super(key: key);

  @override
  State<EditPropertyForm> createState() => _EditPropertyFormState();
}

class _EditPropertyFormState extends State<EditPropertyForm> {
  // Controllers for Text Fields
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _propertyIdController = TextEditingController();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _amenitiesController = TextEditingController();
  String selectedImageUrl = '';
  File? _videoFile;
  File? _thumbnailFile;
  Future<Map<String, dynamic>?>? _propertydetails;

  @override
  void initState() {
    super.initState();

    // Pre-fill the fields with existing data
    @override
    void initState() {
      super.initState();

      // Use null-aware operators to avoid null assignment issues
      _propertyIdController.text =
          widget.propertyData['property_id']?.toString() ?? '';
      _userIdController.text = widget.propertyData['user_id']?.toString() ?? '';
      _typeController.text = widget.propertyData['type'] ?? '';
      _nameController.text = widget.propertyData['name'] ?? '';
      _locationController.text = widget.propertyData['location'] ?? '';
      _priceController.text = widget.propertyData['price']?.toString() ?? '';
      _descriptionController.text = widget.propertyData['description'] ?? '';
      _mobileController.text = widget.propertyData['mobile']?.toString() ?? '';
      _amenitiesController.text = widget.propertyData['amenities'] ?? '';
    }
  }

  // Pick a video file
  Future<void> _pickVideo() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);
    if (result != null) {
      setState(() {
        _videoFile = File(result.files.single.path!);
      });
    }
  }

  // Pick an image file
  Future<void> _pickThumbnail() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _thumbnailFile = File(pickedFile.path);
      });
    }
  }

  // Submit form
  void _submitForm() {
    final formData = {
      'property_id': _propertyIdController.text,
      'user_id': _userIdController.text,
      'type': _typeController.text,
      'name': _nameController.text,
      'location': _locationController.text,
      'price': _priceController.text,
      'description': _descriptionController.text,
      'mobile': _mobileController.text,
      'amenities': _amenitiesController.text,
      'video': _videoFile,
      'thumbnail': _thumbnailFile,
    };

    print('Submitted Data: $formData');
    // Here you can call your API using the collected data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Property')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _propertyIdController,
              decoration: InputDecoration(labelText: 'Property ID'),
            ),
            TextField(
              controller: _userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _mobileController,
              decoration: InputDecoration(labelText: 'Mobile'),
            ),
            TextField(
              controller: _amenitiesController,
              decoration: InputDecoration(labelText: 'Amenities'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickVideo,
              child:
                  Text(_videoFile == null ? 'Select Video' : 'Video Selected'),
            ),
            ElevatedButton(
              onPressed: _pickThumbnail,
              child: Text(_thumbnailFile == null
                  ? 'Select Thumbnail'
                  : 'Thumbnail Selected'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ApiService {
  static const String baseUrl = "https://quantapixel.in/realestate/api/";

  static Future<Map<String, dynamic>?> getPropertyDetails(
      int propertyId) async {
    final url = Uri.parse("${baseUrl}getPropertyDetails");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"property_id": propertyId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      return null;
    }
  }
}
