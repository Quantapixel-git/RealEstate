import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/bottomnav/reels/propertyservices.dart';
import 'package:real_estate_quantapixel/bottomnav/reels/ReelScreen.dart';
import 'package:real_estate_quantapixel/bottomnav/search/search.dart';

class Estateshortshp extends StatefulWidget {
  const Estateshortshp({super.key});

  @override
  State<Estateshortshp> createState() => _EstateshortshpState();
}

class _EstateshortshpState extends State<Estateshortshp> {
  List<Map<String, dynamic>> properties = [];
  late PageController _pageController;
  bool isLoading = true; // Track initial loading state
  bool isLoadingMore = false; // Track loading more properties
  int lastFetchedId = 0; // Keep track of the last fetched property ID

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    loadProperties();
  }

  Future<void> loadProperties() async {
    List<Map<String, dynamic>> fetchedProperties =
        await PropertyService.fetchTopFiveProperties();

    // Filter properties to include only those of type "reel"
    List<Map<String, dynamic>> filteredProperties = fetchedProperties
        .where((property) => property['property_type'] == 'reel')
        .toList();

    if (filteredProperties.isNotEmpty) {
      lastFetchedId = filteredProperties.last['id']; // Update last fetched ID
    }

    setState(() {
      properties = filteredProperties;
      isLoading = false; // Stop loading state
    });
  }

  Future<void> loadMoreProperties() async {
    if (isLoadingMore) return; // Prevent multiple calls
    isLoadingMore = true;

    List<Map<String, dynamic>> nextProperties =
        await PropertyService.fetchNextFiveProperties(lastFetchedId);

    List<Map<String, dynamic>> filteredNextProperties = nextProperties
        .where((property) => property['property_type'] == 'reel')
        .toList();

    if (filteredNextProperties.isNotEmpty) {
      lastFetchedId =
          filteredNextProperties.last['id']; // Update last fetched ID
      setState(() {
        properties
            .addAll(filteredNextProperties); // Add new properties to the list
      });
    }

    isLoadingMore = false; // Reset loading state
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
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
          ? const Center(child: CircularProgressIndicator())
          : properties.isEmpty
              ? const Center(
                  child: Text(
                    "No properties found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];

                    // Load more properties when reaching the last item
                    if (index == properties.length - 1) {
                      loadMoreProperties();
                    }

                    return ReelsScreen(
                      id: property['id']?.toString() ??
                          "Unknown", // Convert to String
                      userid: property['user_id']?.toString() ??
                          "Unknown", // Convert to String
                      location: property['location'] ?? "Unknown",
                      description: property['description'] ?? "No description",
                      mobile: property['mobile'] ?? "No contact",
                      username: property['user_name'] ?? "Unknown user",
                      price: property['price']?.toString() ??
                          "Price not available", // Convert price if it's an int
                      propertyid: property['id']?.toString() ??
                          "Unknown", // Convert to String
                      url: property["video_url"] ?? "",
                      name: property["property_name"] ?? "No name",
                    );
                  },
                ),
    );
  }
}
