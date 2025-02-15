import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/widgets/democlass.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  bool? isHome;
  final String videoUrl;
  final double height;
  final double width;
  final String name;

  VideoScreen({
    Key? key,
    required this.isHome,
    required this.name,
    required this.videoUrl,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.videoUrl);
  }

  void _initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.asset(url)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          // Video Player: Configurable height and width
          _videoPlayerController.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: widget.width, // Use the passed width
                    height: widget.height, // Use the passed height
                    child: VideoPlayer(_videoPlayerController),
                  ),
                )
              : Center(child: CircularProgressIndicator()),

          // Overlay (e.g., captions, buttons)
          widget.isHome!
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Contact Agent Button
                        Container(
                          //  width: MediaQuery.of(context).size.width * 0.65,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 1),
                              backgroundColor:
                                  const Color.fromARGB(255, 240, 235, 105)
                                      .withOpacity(0.9), // Subtle green
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
                                  widget.name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(CupertinoIcons.chat_bubble_text_fill,
                                    size: 22.0,
                                    color: const Color.fromARGB(255, 0, 0, 0)),
                                SizedBox(width: 12),
                                Icon(Icons.call, color: Colors.black),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Video Info Overlay with refined styling
                        Container(
                            decoration: BoxDecoration(
                          color: Colors.black.withOpacity(
                              0.7), // Darker background for contrast
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              offset: Offset(2, 4),
                              blurRadius: 8,
                            ),
                          ],
                        ))
                      ]))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Property Name or Details',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.white),
                          SizedBox(width: 16),
                          Icon(Icons.share, color: Colors.white),
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
