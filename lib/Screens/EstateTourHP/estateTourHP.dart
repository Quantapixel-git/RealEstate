import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Screens/EstateTourHP/facilities.dart';
import 'package:real_estate_quantapixel/Screens/EstateTourHP/tryy.dart';
import 'package:real_estate_quantapixel/Screens/estateShorts/searchShortsPage.dart';
import 'package:real_estate_quantapixel/widgets/democlass.dart';
import 'package:real_estate_quantapixel/widgets/textwidget.dart';

class EstateTourHP extends StatefulWidget {
  const EstateTourHP({super.key});

  @override
  State<EstateTourHP> createState() => _EstateTourHPState();
}

class _EstateTourHPState extends State<EstateTourHP> {
  bool _isExpanded = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white, // White AppBar background
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              height: 50,
              child: Image.asset('assets/1.png'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Searchshortspage()),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black, spreadRadius: 2)
                    ],
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // Black background for search bar
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search,
                          color: Color.fromARGB(
                              255, 0, 0, 0)), // White search icon
                      const SizedBox(width: 10),
                      Text(
                        "Search...",
                        style: TextStyle(
                            color: const Color.fromARGB(
                                255, 0, 0, 0)), // White text
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: estateList.length,
              itemBuilder: (context, index) {
                final estates = estateList[index];

                return Column(
                  children: [
                    // Video Section
                    Container(
                      height: screenHeight * 0.4,
                      width: screenWidth,
                      child: VideoScreen(
                        isHome: false,
                        videoUrl: estates.url,
                        height: screenHeight * 0.4,
                        width: screenWidth,
                        name: estates.Name,
                      ),
                    ),

                    // Property Details
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 8,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Property Header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        estates.Name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.grey),
                                          const SizedBox(width: 8),
                                          Text(
                                            estates.Location,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    estates.price,
                                    style: GoogleFonts.poppins(
                                      color: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 15),

                              // Contact Agent Button
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: Colors.greenAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  elevation: 5,
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Contact Agent',
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.chat_bubble,
                                        color: Colors.black),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.call, color: Colors.black),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Description with Expandable Functionality
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Text(
                                  _isExpanded
                                      ? estates.description
                                      : estates.description.length > 100
                                          ? estates.description
                                                  .substring(0, 100) +
                                              "..."
                                          : estates.description,
                                  style: GoogleFonts.exo(
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w500,
                                    wordSpacing: 6,
                                  ),
                                ),
                              ),
                              if (!_isExpanded)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isExpanded = true;
                                    });
                                  },
                                  child: Text("Show More",
                                      style: TextStyle(color: Colors.blue)),
                                ),

                              const SizedBox(height: 20),

                              // Facilities
                              Facilities(),

                              const SizedBox(height: 20),

                              // Scroll-Up Notice
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.arrow_upward,
                                      color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Scroll Up to View More!',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
