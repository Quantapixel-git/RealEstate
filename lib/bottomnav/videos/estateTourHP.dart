import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/bottomnav/Propertydetail/propertydetail.dart';
import 'package:real_estate_quantapixel/bottomnav/videos/estateapi.dart';
import 'package:real_estate_quantapixel/bottomnav/search/search.dart';
import 'package:real_estate_quantapixel/bottomnav/videos/tryy.dart';
import 'package:real_estate_quantapixel/chating/chatlistscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EstateTourHP extends StatefulWidget {
  const EstateTourHP({super.key});

  @override
  State<EstateTourHP> createState() => _EstateTourHPState();
}

class _EstateTourHPState extends State<EstateTourHP> {
  bool _isExpanded = false;
  late PageController _pageController;
  List<EstateTours> estateList = [];
  bool isLoading = true;

  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    fetchAllProperties();
  }

  Future<void> fetchAllProperties() async {
    try {
      EstateApi estateApi = EstateApi();
      List<EstateTours> allProperties = await estateApi.fetchAllProperties();

      // Debugging: Print each property's type before filtering
      for (var estate in allProperties) {
        print(
            "DEBUG: Property Name: ${estate.Name}, Type: '${estate.propertyType}'");
      }

      // **Filter only properties with type "video"**
      estateList = allProperties
          .where(
              (estate) => estate.propertyType.toLowerCase().trim() == 'video')
          .toList();

      // Debugging: Print filtered properties
      print("Filtered Estate List: ${estateList.length} items");

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching properties: $e");
      setState(() {
        isLoading = false;
      });
    }
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
        automaticallyImplyLeading: false,
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
          SizedBox(
            width: 23,
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : estateList.isEmpty
              ? Center(child: Text("No videos available"))
              : Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        scrollDirection: Axis.vertical,
                        controller: _pageController,
                        itemCount: estateList.length,
                        // Inside the PageView.builder
                        itemBuilder: (context, index) {
                          final estates = estateList[index];

                          return Stack(
                            children: [
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 0,
                                height: screenHeight *
                                    0.5, // Set the height of the video screen
                                child: Container(
                                  child: VideoScreen(
                                    videoUrl: estates.url,
                                    height: screenHeight * 0.5,
                                    width: screenWidth,
                                    location: estates.Location,
                                    price: estates.price,
                                    mobile: estates
                                        .mobile, // Assuming you have this information
                                    propertyId:
                                        estates.id, // Pass the property ID
                                  ),
                                ),
                              ),
                              // Container for Property Details
                              Positioned(
                                top: screenHeight *
                                    0.4, // Adjust this value to control how much of the video is visible
                                left: 0,
                                right: 0,
                                bottom: 0,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  style: const TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                        Icons.location_on,
                                                        color: Colors.grey),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      estates.Location,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.grey[700],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '₹${estates.price.replaceAll('\$', '')}', // Remove $ symbol before adding ₹
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 15),

                                        // Contact Agent Button
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10),
                                            backgroundColor:
                                                Colors.blue.shade900,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            elevation: 2,
                                          ),
                                          onPressed: () {
                                            // You can add any action here if needed
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                estates
                                                    .userName, // Display the username
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              InkWell(
                                                onTap: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  int? senderId = prefs.getInt(
                                                      'id'); // Fetch sender ID as an integer

                                                  if (senderId == null) {
                                                    // Handle missing ID case
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                            'User ID not found. Please log in again.'),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatScreen(
                                                        receiverId: estates
                                                            .userId
                                                            .toString(),
                                                        propertyId: estates.id,
                                                        senderId: senderId
                                                            .toString(), // Convert int to String before passing
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Icon(
                                                  CupertinoIcons
                                                      .chat_bubble_text_fill,
                                                  size: 22.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              GestureDetector(
                                                onTap: () => _makePhoneCall(estates
                                                    .mobile), // Call the mobile number
                                                child: Icon(Icons.call,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Text(
                                              "Description:",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Description with Expandable Functionality
                                        Text(
                                          estates.description,
                                          //  estates.description.length > 100
                                          // ? '${estates.description.substring(0, 100)}...'
                                          // : estates.description,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w500,
                                            wordSpacing: 6,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        // if (!_isExpanded)
                                        Text(
                                          "Amenities:",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),

                                        // Assuming amenities is a comma-separated string
                                        Text(
                                          estates
                                              .amenities, // Display the amenities
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey[700],
                                          ),
                                        ),

                                        const SizedBox(height: 20),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(
                                              Icons.arrow_upward,
                                              color: Colors.grey,
                                              size: 15,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Swipe Up to View More!',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Video Screen at the top
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
