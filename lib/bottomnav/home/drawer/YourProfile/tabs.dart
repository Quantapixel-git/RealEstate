import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:real_estate_quantapixel/bottomnav/Propertydetail/propertydetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileTabs extends StatefulWidget {
  @override
  _ProfileTabsState createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs> {
  List reels = [];
  List videos = [];
  List savedProperties = [];
  bool isLoading = true;
  int? userId;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? storedUserId = prefs.getInt('id');

    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
        isLoading = true;
      });
      await fetchUserProperties(storedUserId);
      await fetchSavedProperties(storedUserId);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserProperties(int userId) async {
    final url = Uri.parse("https://adshow.in/app/api/getAllPropertiesByUserId");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 1) {
        setState(() {
          reels = result['data']
              .where((p) => p['property_type'] == 'reel')
              .toList();
          videos = result['data']
              .where((p) => p['property_type'] == 'video')
              .toList();
        });
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchSavedProperties(int userId) async {
    final url =
        Uri.parse("https://adshow.in/app/api/getAllSavedPropertiesByUserId");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 1) {
        setState(() {
          savedProperties = result['data'];
        });
      }
    }
  }

  Future<void> unsaveProperty(int propertyId) async {
    if (userId == null) return;

    final url = Uri.parse("https://adshow.in/app/api/removeSavedVideo");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"user_id": userId, "property_id": propertyId}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['status'] == 1) {
        setState(() {
          savedProperties.removeWhere((property) =>
              int.tryParse(property['id'].toString()) ==
              propertyId); // Safely parse property ID
        });
      } else {
        print("Error unsaving property: ${result['message']}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.blue.shade400,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              tabs: [
                Tab(icon: Icon(Icons.grid_on), text: 'Reels'),
                Tab(icon: Icon(Icons.video_library), text: 'Videos'),
                Tab(icon: Icon(Icons.bookmark), text: 'Saved'),
              ],
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : userId == null
                      ? Center(child: Text("No Data available"))
                      : TabBarView(
                          children: [
                            buildGrid(reels),
                            buildGrid(videos),
                            buildGrid(savedProperties, isSaved: true),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(List properties, {bool isSaved = false}) {
    return properties.isEmpty
        ? Center(child: Text("No data available"))
        : GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyDetailScreen(
                        propertyId: int.tryParse(property['id'].toString()) ??
                            0, // Safely parse property ID
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        property["thumbnail_url"],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported, size: 50),
                      ),
                    ),
                    if (isSaved)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => unsaveProperty(
                              int.tryParse(property["id"].toString()) ??
                                  0), // Safely parse property ID
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            child: Icon(
                              Icons.bookmark,
                              color: Colors.blue,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
  }
}
