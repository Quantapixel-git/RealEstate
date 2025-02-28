import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/bottomnav/reels/bottomsheet.dart';
import 'package:real_estate_quantapixel/bottomnav/Propertydetail/propertydetail.dart';
import 'package:real_estate_quantapixel/chating/chatlistscreen.dart';
import 'package:real_estate_quantapixel/bottomnav/reels/propertyservices.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ReelsScreen extends StatefulWidget {
  final String url,
      id,
      name,
      propertyid,
      location,
      price,
      description,
      mobile,
      username,
      userid;
  const ReelsScreen(
      {super.key,
      required this.id,
      required this.userid,
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
  bool isLiked = false; // Track if the video is liked
  bool isSaved = false;
  bool _isVideoPlaying = false;
  List<Map<String, dynamic>> topProperties = [];

  Future<void> fetchTopProperties() async {
    List<Map<String, dynamic>> updatedProperties =
        await PropertyService.fetchTopFiveProperties();
    setState(() {
      topProperties = updatedProperties;
    });
  }

  String getShortenedName(String name) {
    List<String> words = name.split(' ');
    if (words.length > 2) {
      return '${words[0]} ${words[1]}...';
    }
    return name;
  }

  Future<PropertyDetails?> fetchPropertyDetails(int propertyId) async {
    try {
      final response = await http.post(
        Uri.parse('https://adshow.in/app/api/getPropertyDetails'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'property_id': propertyId}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 1) {
          return PropertyDetails.fromJson(jsonResponse['data']);
        }
      }
    } catch (e) {
      print("Error fetching property details: $e");
    }
    return null;
  }

  void shareProperty() {
    String shareText = "🏡 Check out this amazing property!\n\n"
        "📍 Location: ${widget.location}\n"
        "💰 Price: ${widget.price}\n"
        "📞 Contact: ${widget.mobile}\n"
        "🔗 Video URL: ${widget.url}\n\n";
    // "🔗 View more details: [Your Property URL Here]";

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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    final Map<String, dynamic> body = {
      "user_id": userId,
      "property_id": propertyId,
    };

    // Make the API call
    final response = await http.post(
      Uri.parse('https://adshow.in/app/api/storeSavedVideo'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      bool success = responseData['status'] == 1;

      setState(() {
        isSaving = false;
        isSaved = success;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              success ? "Video saved successfully!" : "Video already saved."),
        ),
      );
    } else {
      setState(() {
        isSaving = false;
      });

      String errorMessage;
      try {
        final responseData = json.decode(response.body);
        errorMessage = responseData['message'] ?? "Failed to save video.";
      } catch (e) {
        errorMessage = "Failed to save video. Please try again.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> likeVideo(int propertyId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User  ID is not available. Please log in.")),
      );
      return;
    }

    final Map<String, dynamic> body = {
      "user_id": userId,
      "property_id": propertyId,
    };

    final response = await http.post(
      Uri.parse('https://adshow.in/app/api/storeLikedVideo'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      bool success =
          responseData['status'] == 1; // Check if the like was successful

      setState(() {
        isLiked =
            success; // Update the isLiked state based on the success of the like operation
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              success ? "Video liked successfully!" : "Video already liked."),
        ),
      );
    } else {
      String errorMessage;
      try {
        final responseData = json.decode(response.body);
        errorMessage = responseData['message'] ?? "Failed to like video.";
      } catch (e) {
        errorMessage = "Failed to like video. Please try again.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.url);
    fetchTopProperties();
  }

  void _initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url))
      ..initialize().then((_) {
        setState(() {
          _isVideoPlaying = true; // Set to true when video starts playing
        });
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
      }).catchError((error) {});
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
          _videoPlayerController.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_isVideoPlaying) {
                        _videoPlayerController.pause();
                      } else {
                        _videoPlayerController.play();
                      }
                      _isVideoPlaying = !_isVideoPlaying; // Toggle play state
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        VideoPlayer(_videoPlayerController),
                        if (!_isVideoPlaying) // Show play icon only when paused
                          Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 60,
                          ),
                      ],
                    ),
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.username,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () async {
                            // Fetch the current user ID from SharedPreferences as an integer
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            int? userId = prefs
                                .getInt('id'); // Fetches the ID as an integer

                            if (userId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "User ID not found in SharedPreferences")),
                              );
                              return; // Stop execution if userId is null
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  receiverId: widget
                                      .userid, // Assuming you have receiverId available
                                  propertyId: int.parse(widget
                                      .id), // Ensure id is parsed correctly
                                  senderId: userId
                                      .toString(), // Convert userId to String before passing
                                ),
                              ),
                            );
                          },
                          child: Icon(
                            CupertinoIcons.chat_bubble_text_fill,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            makePhoneCall(widget
                                .mobile); // Use the mobile number from the widget
                          },
                          child: Icon(Icons.call, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getShortenedName(
                                widget.name), // Use the helper function here
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              final property = await fetchPropertyDetails(
                                  int.parse(widget.propertyid));
                              if (property != null) {
                                showPropertyDetailsBottomSheet(
                                    context, property);
                              }
                            },
                            child: Text(
                              "View Details",
                              style: GoogleFonts.poppins(
                                color: Colors.blue.shade300,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await likeVideo(
                                        int.parse(widget.propertyid));
                                  },
                                  icon: Icon(
                                    isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: shareProperty,
                                  child: Icon(Icons.share,
                                      color: Colors.white, size: 26),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: isSaving || isSaved
                                      ? null
                                      : () => saveVideo(
                                          int.parse(widget.propertyid)),
                                  child: Icon(
                                    isSaved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
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
                    playedColor: Colors.blue.shade900,
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
