import 'dart:convert'; // Import for json encoding/decoding
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart'; // Import the share_plus package
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences

class VideoScreen extends StatefulWidget {
  final String videoUrl;
  final double height;
  final double width;
  final String location; // Add location parameter
  final String price; // Add price parameter
  final String mobile; // Add mobile parameter
  final int propertyId; // Add propertyId parameter

  VideoScreen({
    Key? key,
    required this.videoUrl,
    required this.height,
    required this.width,
    required this.location,
    required this.price,
    required this.mobile,
    required this.propertyId, // Pass propertyId
  }) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  bool isLiked = false; // Track if the video is liked
  bool isSaving = false; // Track if the video is being saved
  bool isSaved = false; // Track if the video is saved

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.videoUrl);
  }

  void _initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.network(url)
      ..initialize().then((_) {
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

  void shareProperty() {
    String shareText = "🏡 Check out this amazing property!\n\n"
        "📍 Location: ${widget.location}\n"
        "💰 Price: ${widget.price}\n"
        "📞 Contact: ${widget.mobile}\n"
        "🔗 Video URL: ${widget.videoUrl}\n\n";

    Share.share(shareText);
  }

  Future<void> saveVideo() async {
    setState(() => isSaving = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');

    final Map<String, dynamic> body = {
      "user_id": userId,
      "property_id": widget.propertyId,
    };

    // Make the API call
    final response = await http.post(
      Uri.parse('https://quantapixel.in/realestate/api/storeSavedVideo'),
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

  Future<void> likeVideo() async {
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
      "property_id": widget.propertyId,
    };

    final response = await http.post(
      Uri.parse('https://quantapixel.in/realestate/api/storeLikedVideo'),
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
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        _videoPlayerController.value.isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: widget.width,
                  height: widget.height,
                  child: VideoPlayer(_videoPlayerController),
                ),
              )
            : Center(child: CircularProgressIndicator()),

        // Overlay for icons
        Positioned(
          left: 20, // Adjust the left position as needed
          bottom: 100, // Adjust the top position as needed
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  likeVideo(); // Call likeVideo when tapped
                },
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: shareProperty, // Call shareProperty when tapped
                child: Icon(Icons.share, color: Colors.white),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  saveVideo(); // Call saveVideo when tapped
                },
                child: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_outline,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
