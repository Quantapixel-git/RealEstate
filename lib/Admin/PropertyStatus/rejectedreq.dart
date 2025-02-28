import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class RejectedPropertiesScreen extends StatefulWidget {
  @override
  _RejectedPropertiesScreenState createState() =>
      _RejectedPropertiesScreenState();
}

class _RejectedPropertiesScreenState extends State<RejectedPropertiesScreen> {
  List<dynamic> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://adshow.in/app/api/getAllRejectedProperties'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          setState(() {
            properties = data['data'];
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load properties: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load properties: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching properties: $e')),
      );
    }
  }

  Future<void> deleteProperty(int propertyId) async {
    try {
      final response = await http.post(
        Uri.parse('https://adshow.in/app/api/deleteProperty'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'property_id': propertyId}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        fetchProperties(); // Refresh the list after deletion
      } else {
        throw Exception('Failed to delete property');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting property: $e')),
      );
    }
  }

  void showDeleteConfirmationDialog(String propertyId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Property"),
        content: Text("Are you sure you want to delete this property?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              deleteProperty(int.parse(propertyId)); // Convert to int
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Rejected Properties',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'Pull down to refresh',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchProperties,
              child: properties.isEmpty
                  ? Center(
                      child: Text(
                        'No rejected properties found',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: properties.length,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      itemBuilder: (context, index) {
                        final property = properties[index];
                        return Card(
                          margin: EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 150,
                                        child: Image.network(
                                          property['thumbnail_url'],
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(Icons.broken_image,
                                                      size: 100,
                                                      color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        showDeleteConfirmationDialog(
                                            property['id']
                                                .toString()); // Pass as String
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  property['property_name'],
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Location: ${property['location']}',
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                                Text(
                                  'Price: ${property['price']}',
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                                Text(
                                  'Description: ${property['description']}',
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                                Text(
                                  'Amenities: ${property['amenities']}',
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
