import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:real_estate_quantapixel/bottomnav/home/mainhome/mymodel.dart';

Future<List<Reel>> fetchReels() async {
  final response = await http.get(Uri.parse('https://quantapixel.in/realestate/api/getTopFiveRandomHomeReels'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body)['data'];
    return jsonData.map((json) => Reel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load reels');
  }
}

Future<List<Reel>> fetchVideos() async {
  final response = await http.get(Uri.parse('https://quantapixel.in/realestate/api/getTopFiveRandomHomeVideos'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body)['data'];
    return jsonData.map((json) => Reel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load videos');
  }
}