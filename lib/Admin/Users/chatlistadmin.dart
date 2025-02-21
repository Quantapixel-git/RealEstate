import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:real_estate_quantapixel/Admin/Users/chathistoryadmin.dart';

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
        Uri.parse(
            'https://quantapixel.in/realestate/api/getAllUniqueChatsbyUser'),
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
            chats = responseData['data'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : chats.isEmpty
              ? Center(child: Text('No chats available'))
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];

                    return Card(
                      elevation: 3,
                      // margin: EdgeInsets.symmetric(vertical: 8),
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
                                receiverId: chat['user1'] == widget.userId
                                    ? chat['user2']
                                    : chat['user1'],
                                propertyId: chat['property_id'],
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
}
