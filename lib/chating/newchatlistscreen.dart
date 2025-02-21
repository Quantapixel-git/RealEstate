import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_quantapixel/chating/chatlistscreen.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart'; // Add shimmer effect for loading

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<dynamic> chats = [];
  bool isLoading = true;
  int? userId; // User ID as integer

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id'); // Fetch ID as integer

    if (userId != null) {
      try {
        final response = await http.post(
          Uri.parse(
              'https://quantapixel.in/realestate/api/getAllUniqueChatsbyUser'),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "id": userId, // Send user ID in request body
          }),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);

          if (responseData['status'] == 1) {
            setState(() {
              chats = responseData['data']; // Extract data list
              isLoading = false;
            });
          } else {
            print('API Error: ${responseData['message']}');
            setState(() {
              isLoading = false;
            });
          }
        } else {
          print('Failed to load chats: ${response.body}');
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print('Error fetching chats: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('User ID not found in SharedPreferences');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chats',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        // centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? _buildLoadingList()
          : chats.isEmpty
              ? Center(
                  child: Text(
                    'No chats available',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      // margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        leading: chat['thumbnail_url'] != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  chat['thumbnail_url'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey.shade300,
                                child: Icon(Icons.image, color: Colors.grey),
                              ),
                        title: Text(
                          chat['property_name'] ?? 'Unknown Property',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text(
                          chat['latest_message'] ?? 'No messages yet',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          int? senderId = prefs.getInt(
                              'id'); // Fetch sender ID from SharedPreferences

                          if (senderId == null) {
                            print('Error: senderId is null!');
                            return; // Prevent navigation if senderId is missing
                          }

                          int receiverId = (chat['user1'] == senderId)
                              ? chat['user2']
                              : chat['user1'];

                          print('Final senderId: $senderId'); // Debugging
                          print('Final receiverId: $receiverId'); // Debugging

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                receiverId: receiverId.toString(),
                                propertyId: chat['property_id'],
                                senderId: senderId
                                    .toString(), // Pass sender ID correctly
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }

  /// Shimmer effect for loading
  Widget _buildLoadingList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            leading: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
              ),
            ),
            title: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 100,
                height: 16,
                color: Colors.white,
              ),
            ),
            subtitle: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 150,
                height: 12,
                margin: EdgeInsets.only(top: 5),
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
