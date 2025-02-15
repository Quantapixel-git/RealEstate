import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MaterialApp(home: PropertyGridScreen()));
}

class PropertyGridScreen extends StatefulWidget {
  const PropertyGridScreen({super.key});

  @override
  _PropertyGridScreenState createState() => _PropertyGridScreenState();
}

class _PropertyGridScreenState extends State<PropertyGridScreen> {
  List<dynamic> properties = [];
  bool isLoading = false;
  bool hasError = false;
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchTopFiveProperties(); // Load default properties on startup
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Debounce search function to prevent excessive API calls
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (searchController.text.isNotEmpty) {
        fetchProperties(searchController.text);
      } else {
        fetchTopFiveProperties();
      }
    });
  }

  // Fetch top 5 properties initially
  Future<void> fetchTopFiveProperties() async {
    setState(() => isLoading = true);
    const String url =
        "https://quantapixel.in/realestate/api/getTopFiveProperties";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          properties = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  // Fetch properties based on search query
  Future<void> fetchProperties(String query) async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    const String url = "https://quantapixel.in/realestate/api/searchProperties";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": query}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          properties = data.containsKey('data') ? data['data'] : [];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Property Reels")),
      body: Column(
        children: [
          // Search Bar with Auto-Suggest
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search properties...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Search Results / Top 5 Properties
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                    ? const Center(child: Text("Failed to load properties"))
                    : properties.isEmpty
                        ? const Center(child: Text("No properties found"))
                        : GridView.builder(
                            padding: const EdgeInsets.all(10),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: properties.length,
                            itemBuilder: (context, index) {
                              final property = properties[index];
                              return PropertyCard(property: property);
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

// Widget for Property Card
class PropertyCard extends StatelessWidget {
  final dynamic property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VideoPlayerScreen(videoUrl: property['video_url']),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                property['thumbnail_url'],
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['property_name'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Location: ${property['location']}",
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${property['price']}",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Video Player Screen
class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerScreen({super.key, required this.videoUrl});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Property Video")),
      body: Stack(
        alignment: Alignment.center,
        children: [
          _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  if (isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                  isPlaying = !isPlaying;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
