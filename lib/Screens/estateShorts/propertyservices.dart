import 'dart:convert';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:http/http.dart' as http;

class PropertyService {
  static const String _baseUrl = 'https://quantapixel.in/realestate/api';

  // Fetch Top 5 Properties
  static Future<List<Map<String, dynamic>>> fetchTopFiveProperties() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/getTopFiveProperties'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('data') &&
            jsonResponse['data'] is List) {
          return List<Map<String, dynamic>>.from(jsonResponse['data']);
        } else {
          debugPrint('Unexpected response format: $jsonResponse');
          return [];
        }
      } else {
        debugPrint(
            'Failed to fetch properties. Status: ${response.statusCode}, Response: ${response.body}');
        return [];
      }
    } catch (error) {
      debugPrint('Error fetching properties: $error');
      return [];
    }
  }

  // Delete Property
  static Future<bool> deleteProperty(int propertyId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/deleteProperty'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"property_id": propertyId}),
      );

      if (response.statusCode == 200) {
        debugPrint("Property deleted successfully: ${response.body}");
        return true;
      } else {
        debugPrint(
            "Failed to delete property. Status: ${response.statusCode}, Response: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Exception while deleting property: $e");
      return false;
    }
  }
}

class ApiService {
  static const String baseUrl = "https://quantapixel.in/realestate/api/";

  static Future<Map<String, dynamic>?> getPropertyDetails(
      int propertyId) async {
    final url = Uri.parse("${baseUrl}getPropertyDetails");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"property_id": propertyId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      return null;
    }
  }
}
