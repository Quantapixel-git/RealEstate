import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingPropertiesScreen extends StatefulWidget {
  @override
  _PendingPropertiesScreenState createState() =>
      _PendingPropertiesScreenState();
}

class _PendingPropertiesScreenState extends State<PendingPropertiesScreen> {
  List<dynamic> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://quantapixel.in/realestate/api/getAllPendingProperties?status=1'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          setState(() {
            properties = data['data'];
            isLoading = false;
          });
        } else {
          throw Exception('Failed to load properties: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load properties: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching properties: $e')),
      );
    }
  }

  Future<void> updateProperty(int propertyId, int action) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://quantapixel.in/realestate/api/approveRejectProperty'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'property_id': propertyId, 'action': action}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        fetchProperties(); // Refresh the list after action
      } else {
        throw Exception('Failed to update property');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating property')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Pending Properties',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'Pull down to refresh',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchProperties,
              child: ListView.builder(
                itemCount: properties.length,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                itemBuilder: (context, index) {
                  final property = properties[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Video Player
                          Container(
                            width: double.infinity,
                            height: 250,
                            child: VideoPlayerWidget(
                              videoUrl: property['video_url'],
                              thumbnailUrl: property['thumbnail_url'],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            property['property_name'],
                            style: GoogleFonts.poppins(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Location: ${property['location']}',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            'Price: ${property['price']}',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            'Description: ${property['description']}',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            'Amenities: ${property['amenities']}',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            'User Name: ${property['user_name']}',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            'User Mobile: ${property['user_mobile']}',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          Text(
                            'Property Type: ${property['property_type']}',
                            style: GoogleFonts.poppins(fontSize: 14),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () =>
                                    updateProperty(property['id'], 1),
                                child: Text('✔️ Approve',
                                    style: GoogleFonts.poppins(fontSize: 14)),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    updateProperty(property['id'], 3),
                                child: Text('❌ Reject',
                                    style: GoogleFonts.poppins(fontSize: 14)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;

  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    required this.thumbnailUrl,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void playVideo() async {
    await _controller.initialize();
    setState(() {
      isPlaying = true;
    });
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (!isPlaying)
          GestureDetector(
            onTap: playVideo,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.thumbnailUrl,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        if (isPlaying)
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
      ],
    );
  }
}
