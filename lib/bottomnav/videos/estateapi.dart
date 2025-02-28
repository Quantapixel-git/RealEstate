import 'dart:convert';
import 'package:http/http.dart' as http;

class EstateTours {
  final int id; // Added ID field
  final int userId; // Added user_id field
  final String userName; // Added user_name field
  final String userMobile; // Added user_mobile field
  final String url;
  final String Name; // Changed to lowercase for convention
  final String Location; // Changed to lowercase for convention
  final String price;
  final String description;
  final String propertyType; // Added property_type field
  final String thumbnailUrl; // Added thumbnail_url field
  final String mobile; // Added mobile field
  final String amenities; // Added amenities field

  EstateTours({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userMobile,
    required this.url,
    required this.Name,
    required this.Location,
    required this.price,
    required this.description,
    required this.propertyType,
    required this.thumbnailUrl,
    required this.mobile,
    required this.amenities,
  });

  factory EstateTours.fromJson(Map<String, dynamic> json) {
    return EstateTours(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id'].toString()) ?? 0,
      userName: json['user_name'] ?? '',
      userMobile: json['user_mobile'] ?? '',
      url: json['video_url'] ?? '',
      Name: json['property_name'] ?? '',
      Location: json['location'] ?? '',
      price: json['price'] ?? '',
      description: json['description'] ?? '',
      propertyType: json['property_type'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      mobile: json['mobile'] ?? '',
      amenities: json['amenities'] ?? '',
    );
  }
}

class EstateApi {
  static const String baseUrl = 'https://adshow.in/app/api/';

  Future<List<EstateTours>> fetchEstates() async {
    final response =
        await http.get(Uri.parse('${baseUrl}getTopFiveProperties'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 1) {
        List<EstateTours> allProperties = (data['data'] as List)
            .map((item) => EstateTours.fromJson(item))
            .toList();

        // Debug: Print received property types
        for (var estate in allProperties) {
          print(
              "DEBUG: Property Name: ${estate.Name}, Type: '${estate.propertyType}'");
        }

        print("Fetched Properties: ${allProperties.length}");
        return allProperties; // No filtering yet
      } else {
        throw Exception('Failed to load properties: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load properties: ${response.statusCode}');
    }
  }

  Future<List<EstateTours>> fetchNextEstates(int lastId) async {
    final response = await http.post(
      Uri.parse('${baseUrl}getNextFiveProperties'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'last_id': lastId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 1) {
        List<EstateTours> allProperties = (data['data'] as List)
            .map((item) => EstateTours.fromJson(item))
            .toList();

        // Debug: Print received property types
        for (var estate in allProperties) {
          print(
              "DEBUG: Property Name: ${estate.Name}, Type: '${estate.propertyType}'");
        }

        print("Fetched Next Properties: ${allProperties.length}");
        return allProperties; // No filtering yet
      } else {
        throw Exception('Failed to load properties: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load properties: ${response.statusCode}');
    }
  }

  // Fetch all properties in a loop
  Future<List<EstateTours>> fetchAllProperties() async {
    List<EstateTours> allProperties = [];

    // Fetch first batch
    List<EstateTours> topProperties = await fetchEstates();
    allProperties.addAll(topProperties);

    if (topProperties.isNotEmpty) {
      int lastId = topProperties.last.id;

      while (true) {
        // Fetch next batch
        List<EstateTours> nextProperties = await fetchNextEstates(lastId);

        if (nextProperties.isEmpty) {
          break;
        }

        allProperties.addAll(nextProperties);
        lastId = nextProperties.last.id;
      }
    }

    print("Total Properties Retrieved: ${allProperties.length}");
    return allProperties; // Return everything, no filter here
  }
}
