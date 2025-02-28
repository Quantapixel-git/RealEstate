import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_quantapixel/Auth/LoginPage.dart';
import 'package:real_estate_quantapixel/bottomnav/home/drawer/YourProfile/MainProfileScreen.dart';
import 'package:real_estate_quantapixel/bottomnav/BottomnavBar.dart';
import 'package:real_estate_quantapixel/bottomnav/home/drawer/contactus.dart';
import 'package:real_estate_quantapixel/bottomnav/home/drawer/editprofile.dart';
import 'package:real_estate_quantapixel/bottomnav/home/drawer/likedproperty.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Drawerwidgett extends StatefulWidget {
  const Drawerwidgett({super.key});

  @override
  State<Drawerwidgett> createState() => _DrawerwidgetState();
}

class _DrawerwidgetState extends State<Drawerwidgett> {
  String name = "Loading...";
  String phoneNumber = "Loading...";
  bool isProfileLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadProfileFromPrefs();
  }

  // Load profile from SharedPreferences
  Future<void> _loadProfileFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? "User";
      phoneNumber = prefs.getString('mobile') ?? "Not Available";
    });

    if (!isProfileLoaded) {
      _fetchProfileFromAPI();
    }
  }

  // Fetch profile from API only once after login
  Future<void> _fetchProfileFromAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    if (userId == null) return;

    final String apiUrl = "https://adshow.in/app/api/get-profile";
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode({"user_id": userId}),
        headers: {'Content-Type': 'application/json'},
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData["status"] == 1) {
        final data = responseData["data"];
        setState(() {
          name = data["name"];
          phoneNumber = data["mobile"];
          isProfileLoaded = true; // Prevents unnecessary API calls
        });

        // Store updated data in SharedPreferences
        await prefs.setString('name', name);
        await prefs.setString('mobile', phoneNumber);
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          name: name,
          phoneNumber: phoneNumber,
        ),
      ),
    ).then((result) async {
      if (result != null) {
        setState(() {
          name = result['name'];
          phoneNumber = result['phoneNumber'];
        });

        // Store updated profile in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', name);
        await prefs.setString('mobile', phoneNumber);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              name,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            accountEmail: Text(
              phoneNumber,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person, size: 40, color: Colors.black),
            ),
            decoration: BoxDecoration(
              color: Colors.blue.shade900,
            ),
            otherAccountsPictures: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: _navigateToEditProfile,
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              'Home',
              style: GoogleFonts.poppins(fontSize: 17),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BottomNavBar()));
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Your Profile',
              style: GoogleFonts.poppins(fontSize: 17),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => YourProfile()));
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.bookmark_fill),
            title: Text(
              'Liked Properties',
              style: GoogleFonts.poppins(fontSize: 17),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LikedPropertiesPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text(
              'Contact us',
              style: GoogleFonts.poppins(fontSize: 17),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactUsScreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(fontSize: 17),
            ),
            onTap: logout, // Calls logout function on tap
          ),
        ],
      ),
    );
  }
}
