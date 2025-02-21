import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailScreen extends StatefulWidget {
  final int propertyId;

  const PropertyDetailScreen({Key? key, required this.propertyId})
      : super(key: key);

  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late Future<PropertyDetails> _propertyDetailsFuture;
  VideoPlayerController? _videoController;
  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _propertyDetailsFuture = fetchPropertyDetails(widget.propertyId);
  }

  Future<PropertyDetails> fetchPropertyDetails(int propertyId) async {
    final response = await http.post(
      Uri.parse('https://quantapixel.in/realestate/api/getPropertyDetails'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'property_id': propertyId}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 1) {
        return PropertyDetails.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to load property details');
      }
    } else {
      throw Exception('Failed to load property details');
    }
  }

  void _playVideo(String videoUrl) {
    setState(() {
      _isVideoPlaying = true;
      _videoController = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
        });
    });
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $launchUri");
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Property Details",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: FutureBuilder<PropertyDetails>(
        future: _propertyDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final property = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video or Thumbnail
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 6)
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _isVideoPlaying && _videoController != null
                              ? VideoPlayer(_videoController!)
                              : Image.network(property.thumbnailUrl,
                                  fit: BoxFit.cover),
                        ),
                      ),
                      if (!_isVideoPlaying)
                        Positioned(
                          child: GestureDetector(
                            onTap: () => _playVideo(property.videoUrl),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.black54,
                              child: Icon(Icons.play_arrow,
                                  size: 40, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Property Name
                  Text(property.propertyName,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900)),

                  // SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow(
                            Icons.location_on, "Location", property.location),
                        _infoRow(Icons.price_change, "Price", property.price,
                            color: Colors.green),
                        _infoRow(Icons.description, "Description",
                            property.description),
                        // _infoRow(Icons.home, "Property Type",
                        //     property.propertyType),
                        _infoRow(
                            Icons.local_offer, "Amenities", property.amenities),
                      ],
                    ),
                  ),

                  SizedBox(height: 10),
                  Divider(),

                  SizedBox(height: 10),
                  // Contact Seller Section
                  Text("Contact Seller",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900)),
                  // SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.blue.shade900),
                    title: Text(property.userName,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text(property.mobile,
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade700)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.phone, color: Colors.green),
                          onPressed: () => makePhoneCall(property.mobile),
                        ),
                        // IconButton(
                        //   icon: Icon(Icons.chat, color: Colors.blue),
                        //   onPressed: () {
                        //     // Navigate to chat screen
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value,
      {Color color = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade900),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(value, style: TextStyle(color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyDetails {
  final int id;
  final String userId;
  final String userName;
  final String userMobile;
  final String mobile;
  final String propertyName;
  final String propertyType;
  final String thumbnailUrl;
  final String videoUrl;
  final String location;
  final String price;
  final String description;
  final String amenities;

  PropertyDetails({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userMobile,
    required this.mobile,
    required this.propertyName,
    required this.propertyType,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.location,
    required this.price,
    required this.description,
    required this.amenities,
  });

  factory PropertyDetails.fromJson(Map<String, dynamic> json) {
    return PropertyDetails(
      id: json['id'],
      userId: json['user_id'].toString(),
      userName: json['user_name'],
      userMobile: json['user_mobile'],
      mobile: json['mobile'],
      propertyName: json['property_name'],
      propertyType: json['property_type'],
      thumbnailUrl: json['thumbnail_url'],
      videoUrl: json['video_url'],
      location: json['location'],
      price: json['price'],
      description: json['description'],
      amenities: json['amenities'],
    );
  }
}
