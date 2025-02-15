import 'package:flutter/material.dart';
import 'package:real_estate_quantapixel/Screens/estateShorts/propertyservices.dart';
import 'package:real_estate_quantapixel/Screens/estateShorts/try.dart';

class Estateshortshp extends StatefulWidget {
  const Estateshortshp({super.key});

  @override
  State<Estateshortshp> createState() => _EstateshortshpState();
}

class _EstateshortshpState extends State<Estateshortshp> {
  List<Map<String, dynamic>> properties = [];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    loadProperties();
  }

  Future<void> loadProperties() async {
    List<Map<String, dynamic>> fetchedProperties =
        await PropertyService.fetchTopFiveProperties();
    setState(() {
      properties = fetchedProperties;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: properties.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];

                return ReelsScreen(
                  location: property['location'] ?? "Unknown",
                  description: property['description'] ?? "No description",
                  mobile: property['mobile'] ?? "No contact",
                  username: property['user_name'] ?? "Unknown user",
                  price: property['price'] ?? "Price not available",
                  propertyid: property['id'].toString(), // Ensure it's a string
                  url: property["video_url"] ?? "",
                  name: property["property_name"] ?? "No name",
                );
              },
            ),
    );
  }
}
