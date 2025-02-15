import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Screens/EstateTourHP/tryy.dart';
import 'package:real_estate_quantapixel/widgets/democlass.dart';
import 'package:real_estate_quantapixel/widgets/demoshorts.dart';
import 'package:real_estate_quantapixel/widgets/drawerwidget.dart';
import 'package:video_player/video_player.dart';

// Mock data for estate shorts
final List<EstateShort> estateshortlist = [
  //EstateShort(url: 'assets/video1.mp4', name: 'Urban Apartment'),
  EstateShort(url: 'assets/video2.mp4', name: 'Luxury Villa'),
  EstateShort(url: 'assets/video3.mp4', name: 'Cozzy Cottage'),
];

class EstateShort {
  final String url;
  final String name;
  EstateShort({required this.url, required this.name});
}

bool _isExpanded = false;
late PageController _pageController;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool _isExpanded = false;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        elevation: 5,
        actions: [
          Icon(
            Icons.search,
            color: const Color.fromARGB(255, 0, 0, 0),
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
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.menu, // This is the menu icon (hamburger icon)
        //     color: Colors.white, // Change this color to your desired color
        //   ),
        //   onPressed: () {
        //     // Open the drawer when clicked
        //     Scaffold.of(context).openDrawer();
        //   },
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  // List of estate shorts
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Estate Shorts',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                  ),
                  SizedBox(
                    height: screenHeight * 0.3, // Adjust height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: estateshortlist.length,
                      itemBuilder: (context, index) {
                        final shorts = estateshortlist[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReelsScreen(
                                  url: shorts.url,
                                  name: shorts.name,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            width: screenWidth * 0.5, // Adjust width
                            child: VideoThumbnailWidget(
                              url: shorts.url,
                              name: shorts.name,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Property Video or Tour',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )),
              ),
              SizedBox(
                height: screenHeight * 0.3,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _pageController,
                    itemCount: estateList.length,
                    itemBuilder: (context, index) {
                      final estate = estateList[index];
                      return VideoScreen(
                          isHome: true,
                          videoUrl: estate.url,
                          height: screenHeight * 0.3,
                          width: screenWidth,
                          name: estate.Name);
                    },
                  ),
                ),
              ),
              WhyChooseUs(),
              CustomerTestimonials(),
              AboutSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(),
    );
  }
}

// Video Thumbnail Widget
class VideoThumbnailWidget extends StatefulWidget {
  final String url;
  final String name;

  const VideoThumbnailWidget({Key? key, required this.url, required this.name})
      : super(key: key);

  @override
  _VideoThumbnailWidgetState createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.url);
  }

  void _initializeVideo(String url) {
    _videoPlayerController = VideoPlayerController.asset(url)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
        _videoPlayerController.setLooping(true);
        _videoPlayerController.setVolume(0.0); // Mute the video
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
    return Stack(
      children: [
        // Video Player
        _videoPlayerController.value.isInitialized
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: VideoPlayer(_videoPlayerController),
              )
            : Center(child: CircularProgressIndicator()),

        // Video Name Overlay
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.name,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ReelsScreen for Full-Screen Playback
class ReelsScreen extends StatefulWidget {
  final String url, name;

  const ReelsScreen({super.key, required this.url, required this.name});

  @override
  _ReelsScreenState createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initializeVideo(widget.url);
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
      appBar: AppBar(
        title: Text(widget.name, style: GoogleFonts.poppins()),
      ),
      body: Center(
        child: _videoPlayerController.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class WhyChooseUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      color: Colors.grey[200],
      child: Column(
        children: [
          Text(
            'Why Choose Us?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildFeatureIcon(
                icon: Icons.verified_user,
                label: 'Trusted by Thousands',
              ),
              _buildFeatureIcon(
                icon: Icons.home,
                label: 'Wide Selection',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureIcon({required IconData icon, required String label}) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.blue.shade700),
        SizedBox(height: 10),
        Text(label, textAlign: TextAlign.center),
      ],
    );
  }
}

class CustomerTestimonials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What Our Clients Say',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text('Great experience!'),
              subtitle: Text('- John Smith'),
            ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text('Found my dream home!'),
              subtitle: Text('- Jane Doe'),
            ),
          ),
        ],
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Us',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'At AdShow, we are committed to connecting people with their dream properties. '
            'Our platform offers a seamless experience to explore a wide range of properties, '
            'from luxury villas to cozy apartments.',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement "Learn More" functionality
            },
            child: Text(
              'Learn More',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade900,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '© 2025 AdShow | All Rights Reserved',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
