import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_quantapixel/bottomnav/Propertydetail/propertydetail.dart';
import 'dart:convert';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List<Property> _properties = [];
  List<Property> _allProperties = []; // Store all properties for filtering
  int _lastId = 0;

  Future<void> _fetchProperties() async {
    try {
      final response = await http.get(Uri.parse(
          'https://quantapixel.in/realestate/api/getTopFiveProperties'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 1) {
          setState(() {
            _properties = (jsonData['data'] as List)
                .map((property) => Property.fromJson(property))
                .toList();
            _allProperties = List.from(_properties);
            _lastId = _properties.isNotEmpty ? _properties.last.id : 0;
          });
        } else {
          print('Error: ${jsonData['message']}');
        }
      } else {
        print('Failed to load properties: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching properties: $e');
    }
  }

  Future<void> _fetchNextProperties() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://quantapixel.in/realestate/api/getNextFiveProperties'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'last_id': _lastId}),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 1) {
          setState(() {
            List<Property> newProperties = (jsonData['data'] as List)
                .map((property) => Property.fromJson(property))
                .toList();
            _properties.addAll(newProperties);
            _allProperties.addAll(newProperties);
            _lastId = newProperties.isNotEmpty ? newProperties.last.id : 0;
          });
        } else {
          print('Error: ${jsonData['message']}');
        }
      } else {
        print('Failed to load next properties: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching next properties: $e');
    }
  }

  void _searchProperties() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _properties = _allProperties.where((property) {
        return property.propertyName.toLowerCase().contains(query) ||
            property.location.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Find Your Property', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.blue.shade900,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: Icon(Icons.search, color: Colors.blue.shade900),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => _searchProperties(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              itemCount: _properties.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailScreen(
                          propertyId: _properties[index].id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 3,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(12)),
                          child: Image.network(
                            _properties[index].thumbnailUrl,
                            width: 120,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _properties[index].propertyName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  _properties[index].location,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _fetchNextProperties,
              child: const Text('Load More',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class Property {
  final int id;
  final String propertyName;
  final String location;
  final String thumbnailUrl;

  Property(
      {required this.id,
      required this.propertyName,
      required this.location,
      required this.thumbnailUrl});

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      propertyName: json['property_name'],
      location: json['location'],
      thumbnailUrl: json['thumbnail_url'],
    );
  }
}
