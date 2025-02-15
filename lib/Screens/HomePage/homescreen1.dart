import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Screens/EstateTourHP/tryy.dart';
import 'package:real_estate_quantapixel/Screens/HomePage/requestApproval.dart';
import 'package:real_estate_quantapixel/Screens/HomePage/uploadreelsVideos.dart';
import 'package:real_estate_quantapixel/Screens/estateShorts/try.dart';
import 'package:real_estate_quantapixel/widgets/drawerwidget.dart';

class YourProfile extends StatefulWidget {
  final int accountStatus; // 1 for active, 0 for inactive

  YourProfile({required this.accountStatus});

  @override
  State<YourProfile> createState() => _YourProfileState();
}

class _YourProfileState extends State<YourProfile> {
  List properties = [];
  int userId = 75; // Example user_id
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTopFiveProperties();
  }

  // Function to fetch top 5 properties
  Future<void> fetchTopFiveProperties() async {
    const String url =
        "https://quantapixel.in/realestate/api/getTopFivePropertiesByUserId";

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          properties = jsonResponse['data']; // Assuming 'data' holds the list
        });
      } else {
        print("Failed to load properties: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching properties: $error");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawerwidgett(),
      appBar: AppBar(
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        title: Row(
          children: [
            Image.asset(
              'assets/1.png',
              height: screenHeight * 0.06,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Adshow',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UploadPropertyScreen()));
            },
            child: Icon(CupertinoIcons.add_circled_solid,
                size: 22.0, color: const Color.fromARGB(255, 0, 0, 0)),
          ),
          SizedBox(
            width: 12,
          ),
          Icon(CupertinoIcons.chat_bubble_text_fill,
              size: 22.0, color: const Color.fromARGB(255, 0, 0, 0)),
          SizedBox(
            width: 23,
          )
        ],
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                      'https://www.w3schools.com/w3images/avatar2.png'),
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sarthak Tehri',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0))),
                      Text('Bio or description',
                          style: TextStyle(
                              color: const Color.fromARGB(179, 0, 0, 0))),
                      if (widget.accountStatus == 1)
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('Seller',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            UploadPropertyScreen()));
                              },
                              child: Icon(CupertinoIcons.add_circled_solid,
                                  size: 30.0,
                                  color: const Color.fromARGB(255, 0, 0, 0)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Icon(Icons.edit, color: Colors.white),
              ],
            ),
          ),

          // Conditional UI based on account status
          if (widget.accountStatus == 1)
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Colors.red.shade400,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.red,
                      tabs: [
                        Tab(icon: Icon(Icons.grid_on), text: 'Reels'),
                        Tab(icon: Icon(Icons.video_library), text: 'Videos'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          GridView.builder(
                              padding: EdgeInsets.all(8),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: properties.length,
                              itemBuilder: (context, index) {
                                final property = properties[index];
                                return GestureDetector(
                                  onTap: () {
                                    // Open video player screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ReelsScreen(
                                              location: property['location'],
                                              description:
                                                  property['description'],
                                              mobile: property['mobile'],
                                              username: property['user_name'],
                                              price: property['price'],
                                              propertyid: property['id'],
                                              url: property["video_url"],
                                              name: property["property_name"])),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    elevation: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(12)),
                                            child: Image.network(
                                              property["thumbnail_url"],
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  Icon(Icons
                                                      .image_not_supported),
                                            ),
                                          ),
                                        ),
                                        // Image.network(
                                        //     property['thumbnail_url']),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            property["property_name"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          GridView.builder(
                            padding: EdgeInsets.all(8),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemCount: 12,
                            itemBuilder: (context, index) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blueAccent,
                              ),
                              child: Icon(Icons.video_collection,
                                  color: Colors.white, size: 50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark, color: Colors.blue.shade900, size: 50),
                  SizedBox(height: 10),
                  Text('Saved Reels & Videos',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900)),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => UserForm()));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 1,
                                blurRadius: 1)
                          ]),
                      child: Column(
                        children: [
                          Icon(Icons.add_circle, color: Colors.red, size: 50),
                          SizedBox(height: 10),
                          Text('If you are a seller, verify to add content',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.blue.shade900)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class VideoPlayerScreen extends StatelessWidget {
  final String videoUrl;
  VideoPlayerScreen({required this.videoUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Player")),
      body: Center(child: Text("Play video: $videoUrl")),
    );
  }
}
