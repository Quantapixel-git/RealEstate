import 'dart:convert';
import 'package:http/http.dart' as http;

class VideoService {
  static const String _baseUrl = "https://quantapixel.in/realestate/api";
  Future<bool> removeSavedVideo(int userId, int propertyId) async {
    final url = Uri.parse("$_baseUrl/removeSavedVideo");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": userId,
          "property_id": propertyId,
        }),
      );

      if (response.statusCode == 200) {
        print("Video removed successfully!");
        return true;
      } else {
        print("Failed to remove video: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  // Function to save a video
  static Future<bool> saveVideo(int userId, int propertyId) async {
    final String url = "$_baseUrl/storeSavedVideo";
    final Map<String, dynamic> requestBody = {
      "user_id": userId,
      "property_id": propertyId,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 201 && responseData["status"] == 1) {
        return true; // Successfully saved
      } else {
        return false; // Failed to save
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> getTopFiveSavedProperties(int userId) async {
    final url = Uri.parse("$_baseUrl/getTopFiveSavedPropertiesByUserId");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Ensure responseData is a Map and contains the property list
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey("data")) {
          return responseData["data"]
              as List<dynamic>; // Extract the "data" list
        } else {
          print("Unexpected API response structure: $responseData");
          return [];
        }
      } else {
        print("Failed to load properties: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching properties: $e");
      return [];
    }
  }
}
