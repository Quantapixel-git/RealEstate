
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

  // Fetch Next 5 Properties
  static Future<List<Map<String, dynamic>>> fetchNextFiveProperties(
      int lastId) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/getNextFiveProperties'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"last_id": lastId}),
      );

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
            'Failed to fetch next properties. Status: ${response.statusCode}, Response: ${response.body}');
        return [];
      }
    } catch (error) {
      debugPrint('Error fetching next properties: $error');
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

Future<void> fetchAllProperties() async {
  List<Map<String, dynamic>> allProperties = [];

  // Fetch the top 5 properties first
  List<Map<String, dynamic>> topProperties =
      await PropertyService.fetchTopFiveProperties();

  if (topProperties.isNotEmpty) {
    // Filter properties to include only those of type "reel"
    List<Map<String, dynamic>> filteredTopProperties = topProperties
        .where((property) => property['property_type'] == 'reel')
        .toList();

    allProperties.addAll(filteredTopProperties);

    // Get the last property ID from the filtered list
    if (filteredTopProperties.isNotEmpty) {
      int lastId = filteredTopProperties.last['id'];

      while (true) {
        // Fetch the next 5 properties
        List<Map<String, dynamic>> nextProperties =
            await PropertyService.fetchNextFiveProperties(lastId);

        if (nextProperties.isEmpty) {
          debugPrint('No more properties to fetch.');
          break; // Exit the loop if no more properties are returned
        }

        // Filter the next properties to include only those of type "reel"
        List<Map<String, dynamic>> filteredNextProperties = nextProperties
            .where((property) => property['property_type'] == 'reel')
            .toList();

        allProperties.addAll(filteredNextProperties);

        // Update the lastId to the last property in the newly fetched properties
        if (filteredNextProperties.isNotEmpty) {
          lastId = filteredNextProperties.last['id'];
        } else {
          debugPrint('No more reel properties to fetch.');
          break; // Exit the loop if no more reel properties are returned
        }
      }
    }
  }

  // Do something with allProperties
  debugPrint('Total reel properties fetched: ${allProperties.length}');
  for (var property in allProperties) {
    debugPrint(property.toString());
  }
}