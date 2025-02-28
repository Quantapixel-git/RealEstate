import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_quantapixel/Admin/Users/chathistoryadmin.dart';
import 'package:shimmer/shimmer.dart'; // Import shimmer package

class ChatListPage extends StatefulWidget {
  final int userId;

  ChatListPage({required this.userId});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<dynamic> chats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  Future<void> _fetchChats() async {
    try {
      final response = await http.post(
        Uri.parse('https://adshow.in/app/api/getAllUniqueChatsbyUser'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "id": widget.userId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 1) {
          setState(() {
            chats = _filterDuplicateChats(responseData['data']);
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<dynamic> _filterDuplicateChats(List<dynamic> chatList) {
    final Map<String, dynamic> uniqueChats = {};

    for (var chat in chatList) {
      // Get the user IDs
      int user1 = int.parse(chat['user1'].toString());
      int user2 = int.parse(chat['user2'].toString());

      // Check if the current user is either user1 or user2
      if (user1 == widget.userId && user2 == widget.userId) {
        continue; // Skip this chat if both users are the same as the current user
      }

      // Create a unique key based on the user IDs
      String key = user1 < user2 ? '$user1-$user2' : '$user2-$user1';

      // Only add the chat if the key is not already in the map
      if (!uniqueChats.containsKey(key)) {
        uniqueChats[key] = chat; // Add unique chat to the map
      }
    }

    return uniqueChats.values.toList(); // Return the unique chats as a list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: isLoading
          ? _buildLoadingList() // Show shimmer effect while loading
          : chats.isEmpty
              ? Center(child: Text('No chats available'))
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];

                    // Determine the receiver ID based on the current user ID
                    int receiverId = chat['user1'] == widget.userId
                        ? int.tryParse(chat['user2'].toString()) ?? 0
                        : int.tryParse(chat['user1'].toString()) ?? 0;

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: chat['thumbnail_url'] != null &&
                                  chat['thumbnail_url'].isNotEmpty
                              ? NetworkImage(chat['thumbnail_url'])
                              : AssetImage('assets/images/placeholder.png')
                                  as ImageProvider,
                        ),
                        title: Text(
                          chat['property_name'] ?? 'Unknown Property',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          chat['latest_message'] ?? 'No messages yet',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: 16, color: Colors.grey),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatHistoryScreen(
                                receiverId: receiverId, // Pass the receiver ID
                                propertyId: int.tryParse(
                                        chat['property_id'].toString()) ??
                                    0, // Safely parse propertyId
                                userId:
                                    widget.userId, // Pass the current user ID
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
      itemCount: 6, // Number of shimmer items
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
