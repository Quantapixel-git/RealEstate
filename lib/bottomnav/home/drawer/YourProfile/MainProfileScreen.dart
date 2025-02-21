import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
// import 'package:real_estate_quantapixel/chating/propertylistscreen.dart';
import 'package:real_estate_quantapixel/bottomnav/home/drawer/YourProfile/Topprofilesection.dart';
import 'package:real_estate_quantapixel/bottomnav/home/drawer/YourProfile/tabs.dart';
import 'package:real_estate_quantapixel/bottomnav/home/drawer/drawerwidget.dart';
import 'package:real_estate_quantapixel/bottomnav/search/search.dart';
// import 'package:real_estate_quantapixel/chating/chatlistscreen.dart';
import 'package:real_estate_quantapixel/chating/newchatlistscreen.dart';

class YourProfile extends StatefulWidget {
  @override
  State<YourProfile> createState() => _YourProfileState();
}

class _YourProfileState extends State<YourProfile> {
  List properties = [];
  int userId = 75;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTopFiveProperties();
  }

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
          properties = jsonResponse['data'];
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
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawerwidgett(),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/1.png', height: 40),
            SizedBox(width: 10),
            Text(
              'Adshow',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
            child: Icon(
              Icons.search,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatListPage()));
            },
            child: Icon(CupertinoIcons.chat_bubble_text_fill,
                size: 22.0, color: const Color.fromARGB(255, 0, 0, 0)),
          ),
          SizedBox(width: 23),
        ],
      ),
      body: Column(
        children: [ProfileHeader(), ProfileTabs()],
      ),
    );
  }
}
