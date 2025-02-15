import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:real_estate_quantapixel/Screens/BottomnavBar.dart';
import 'package:real_estate_quantapixel/Screens/HomePage/editproperty.dart';
import 'package:real_estate_quantapixel/Screens/estateShorts/propertyservices.dart';
import 'package:real_estate_quantapixel/Screens/estateShorts/savevideoservice.dart';
import 'package:real_estate_quantapixel/Screens/estateShorts/searchShortsPage.dart';
import 'package:real_estate_quantapixel/Screens/estateShorts/searchshorts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  final String url,
      name,
      propertyid,
      location,
      price,
      description,
      mobile,
      username;
  const ReelsScreen(
      {super.key,
      required this.location,
      required this.description,
      required this.mobile,
      required this.username,
      required this.price,
      required this.url,
      required this.name,
      required this.propertyid});

  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late VideoPlayerController _videoPlayerController;
  bool isSaving = false;
  bool isSaved = false;
  List<Map<String, dynamic>> topProperties = [];
  Future<void> fetchTopProperties() async {
    List<Map<String, dynamic>> updatedProperties =
        await PropertyService.fetchTopFiveProperties();
    setState(() {
      topProperties = updatedProperties;
    });
  }

  void shareProperty() {
    String shareText = "🏡 Check out this amazing property!\n\n"
        "📍 Location: ${widget.location}\n"
        "💰 Price: ${widget.price}\n"
        "📞 Contact: ${widget.mobile}\n\n"
        "🔗 View more details: [Your Property URL Here]";

    Share.share(shareText);
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri, mode: LaunchMode.externalApplication);
    } else {
      print("Could not launch $launchUri");
    }
  }

  Future<void> saveVideo(int propertyId) async {
    setState(() => isSaving = true);

    // Call the saveVideo method from VideoService
    bool success = await VideoService.saveVideo(
        75, propertyId); // Example user & property ID

    setState(() {
      isSaving = false;
      isSaved =
          success; // Update the isSaved state based on the success of the save operation
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              success ? "Video saved successfully!" : "Video already Saved.")),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.url);
    fetchTopProperties();
  }

  void _initializeVideo(String url) {
    print("Initializing video: $url");
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        print("Video initialized successfully");
        setState(() {});
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
      }).catchError((error) {
        print("Error initializing video: $error");
      });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Video Player
          _videoPlayerController.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1.112,
                    height: MediaQuery.of(context).size.height,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),

          // Safe Area for Header
          SafeArea(
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.2,
                  margin: const EdgeInsets.only(left: 20),
                  child: Image.asset('assets/1.png'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PropertyGridScreen()),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 50,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(0.2), // Transparent effect
                      border: Border.all(color: Colors.white54),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.white54),
                        SizedBox(width: 10),
                        Text("Search...",
                            style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content Overlay
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Contact Agent Button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.greenAccent, // Subtle green
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 5, // Subtle shadow for depth
                    ),
                    onPressed: () {
                      // Handle contact action
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.username,
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(CupertinoIcons.chat_bubble_text_fill,
                            size: 22.0, color: Colors.black),
                        const SizedBox(width: 12),
                        GestureDetector(
                            onTap: () {
                              makePhoneCall('+919884209408');
                            },
                            child: Icon(Icons.call, color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Video Info Overlay
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: const Offset(2, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              widget.price,
                              style: GoogleFonts.exo(
                                color: const Color.fromARGB(255, 248, 18, 18),
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditPropertyForm(
                                                      propertyData: {
                                                        'name': widget.name,
                                                        'price': widget.price,
                                                      })));
                                    },
                                    child: Icon(Icons.edit,
                                        color: Colors.white, size: 26)),
                                const SizedBox(width: 20),
                                IconButton(
                                  onPressed: () async {
                                    int? propertyId =
                                        int.tryParse(widget.propertyid);

                                    if (propertyId == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Invalid Property ID")),
                                      );
                                      return;
                                    }

                                    bool success =
                                        await PropertyService.deleteProperty(
                                            propertyId);

                                    if (success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Property deleted successfully!")),
                                      );
                                      // Refresh the entire screen
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BottomNavBar()),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Failed to delete property.")),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.white, size: 26),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: shareProperty,
                                  child: Icon(Icons.share,
                                      color: Colors.white, size: 26),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: isSaving || isSaved
                                      ? null
                                      : () => saveVideo(int.parse(widget
                                          .propertyid)), // Convert String to int
                                  child: Icon(
                                    isSaved
                                        ? Icons.bookmark
                                        : Icons
                                            .bookmark_border, // Updated for state handling
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Video Progress Bar
          if (_videoPlayerController.value.isInitialized)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: VideoProgressIndicator(
                  _videoPlayerController,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: Colors.greenAccent,
                    bufferedColor: Colors.grey.shade700,
                    backgroundColor: Colors.black38,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
