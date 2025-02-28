import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/bottomnav/home/mainhome/fetchingdataApi.dart';
import 'package:real_estate_quantapixel/bottomnav/home/mainhome/mymodel.dart';
import 'package:real_estate_quantapixel/bottomnav/home/mainhome/aboutus.dart';
import 'package:real_estate_quantapixel/bottomnav/home/mainhome/footer.dart';
import 'package:real_estate_quantapixel/bottomnav/Propertydetail/propertydetail.dart';
import 'package:real_estate_quantapixel/bottomnav/home/mainhome/whychooseus.dart';
import 'package:real_estate_quantapixel/bottomnav/home/drawer/drawerwidget.dart';
import 'package:real_estate_quantapixel/bottomnav/search/search.dart';
import 'package:real_estate_quantapixel/chating/newchatlistscreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Future<List<Reel>> _reelsFuture;
  late Future<List<Reel>> _videosFuture;

  @override
  void initState() {
    super.initState();
    _reelsFuture = fetchReels();
    _videosFuture = fetchVideos();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

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
            width: 12,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatListPage()));
            },
            child: Icon(CupertinoIcons.chat_bubble_text_fill,
                size: 22.0, color: const Color.fromARGB(255, 0, 0, 0)),
          ),
          SizedBox(
            width: 23,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Estate Shorts Section (Improved)
              FutureBuilder<List<Reel>>(
                future: _reelsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final reels = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            'Estate Shorts',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 180, // Adjusted height
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: reels.length,
                            itemBuilder: (context, index) {
                              final reel = reels[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PropertyDetailScreen(
                                              propertyId: reel.id),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 140, // Adjusted width
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26, blurRadius: 6)
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Stack(
                                      children: [
                                        // Property Thumbnail
                                        Positioned.fill(
                                          child: Image.network(
                                            reel.thumbnailUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // Gradient Overlay
                                        Positioned.fill(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.7),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Property Name
                                        Positioned(
                                          bottom: 8,
                                          left: 8,
                                          right: 8,
                                          child: Text(
                                            reel.propertyName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 4),
                                              ],
                                            ),
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),

              SizedBox(height: 20), // Spacing between sections

              Divider(),
// Property Tour - Property Videos Section
              FutureBuilder<List<Reel>>(
                future: _videosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final videos = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Text(
                            'Estate Tour',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 240, // Increased height for better spacing
                          child: ListView.builder(
                            scrollDirection:
                                Axis.vertical, // Keep it scrollable
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              final video = videos[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PropertyDetailScreen(
                                              propertyId: video.id),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 8,
                                          offset: Offset(0, 4))
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SizedBox(
                                      height: 100,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Video Thumbnail
                                          Positioned.fill(
                                            child: Image.network(
                                              video.thumbnailUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          // Dark Gradient Overlay for better text visibility
                                          Positioned.fill(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                    Colors.black
                                                        .withOpacity(0.7),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Play Button Icon
                                          Icon(
                                            Icons.play_circle_fill,
                                            color: Colors.white,
                                            size:
                                                60, // Slightly larger play button
                                          ),
                                          // Property Name (Text Overlay at Bottom)
                                          Positioned(
                                            bottom: 2,
                                            left: 15,
                                            right: 15,
                                            child: Text(
                                              video.propertyName,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                      color: Colors.black,
                                                      blurRadius: 6)
                                                ],
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              WhyChooseUs(),
              AboutSection(),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
