import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_quantapixel/bottomnav/home/drawer/YourProfile/uploadproperty.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHeader extends StatefulWidget {

  @override
  _ProfileHeaderState createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String name = "Loading...";
  String phoneNumber = "";

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    if (userId != null) {
      final String apiUrl = "https://quantapixel.in/realestate/api/get-profile";
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
            name = data["name"] ?? "No Name";
            phoneNumber = data["mobile"] ?? "No Phone Number";
          });
        } else {
          setState(() {
            name = "Failed to load profile";
            phoneNumber = "";
          });
        }
      } catch (e) {
        setState(() {
          name = "Error loading profile";
          phoneNumber = "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade300,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(phoneNumber, style: TextStyle(color: Colors.black54)),
                // if (widget.accountStatus == 1)
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          Text('Seller', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadPropertyScreen()));
                      },
                      child: Icon(CupertinoIcons.add_circled_solid,
                          size: 30.0, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
