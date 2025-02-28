import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_quantapixel/bottomnav/Propertydetail/propertydetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LikedPropertiesPage extends StatefulWidget {
  @override
  _LikedPropertiesPageState createState() => _LikedPropertiesPageState();
}

class _LikedPropertiesPageState extends State<LikedPropertiesPage> {
  List likedProperties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLikedProperties();
  }

  Future<void> fetchLikedProperties() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url =
        Uri.parse("https://adshow.in/app/api/getAllLikedPropertiesByUserId");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 1) {
        setState(() {
          likedProperties = result['data'];
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> removeLikedProperty(int propertyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    if (userId == null) return;

    final url = Uri.parse("https://adshow.in/app/api/removeLikedVideo");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId, "property_id": propertyId}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 1) {
        // Successfully removed liked property
        setState(() {
          likedProperties.removeWhere((property) =>
              int.tryParse(property['id'].toString()) == propertyId);
        });
        // Refresh the list of liked properties
        fetchLikedProperties(); // Re-fetch liked properties
      } else {
        // Handle error if needed
        print("Error removing liked property: ${result['message']}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Liked Properties',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : likedProperties.isEmpty
              ? Center(child: Text("No liked properties available."))
              : ListView.builder(
                  itemCount: likedProperties.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final property = likedProperties[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            property['thumbnail_url'],
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.image_not_supported, size: 50),
                          ),
                        ),
                        title: Text(property['property_name'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(property['location'],
                                style: TextStyle(color: Colors.grey.shade600)),
                            Text("Price: ${property['price']}",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.favorite, color: Colors.red),
                              onPressed: () {
                                int propertyId =
                                    int.tryParse(property['id'].toString()) ??
                                        0; // Safely parse property ID
                                removeLikedProperty(
                                    propertyId); // Call remove method
                              },
                            ),
                            Icon(Icons.arrow_forward_ios,
                                color: Colors.blue.shade900),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyDetailScreen(
                                propertyId:
                                    int.tryParse(property['id'].toString()) ??
                                        0, // Safely parse property ID
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
