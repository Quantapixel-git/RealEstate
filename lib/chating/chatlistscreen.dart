import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For formatting date and time

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final int propertyId;
  final String senderId;

  ChatScreen({
    required this.receiverId,
    required this.propertyId,
    required this.senderId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<dynamic> messages = [];
  bool isLoading = true;
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController(); // To auto-scroll

  @override
  void initState() {
    super.initState();
    _fetchChatHistory();
  }

  Future<void> _fetchChatHistory() async {
    try {
      final response = await http.post(
        Uri.parse('https://quantapixel.in/realestate/api/getChatHistory'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "id": int.parse(widget.receiverId),
          "property_id": widget.propertyId,
        }),
      );

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        if (decodedResponse is Map<String, dynamic> &&
            decodedResponse.containsKey('data')) {
          setState(() {
            messages = decodedResponse['data'];
            isLoading = false;
          });

          // Scroll to bottom after fetching messages
          Future.delayed(Duration(milliseconds: 500), () {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
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

  String _formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('MMM d, yyyy hh:mm a').format(dateTime);
  }

  void _sendMessage() async {
    String message = _messageController.text.trim();
    if (message.isEmpty) return;

    int? senderId = int.tryParse(widget.senderId);
    int? receiverId = int.tryParse(widget.receiverId);

    if (senderId == null || receiverId == null) {
      return;
    }

    Map<String, dynamic> body = {
      "property_id": widget.propertyId,
      "message": message,
      "sender_id": senderId,
      "receiver_id": receiverId,
    };

    try {
      final response = await http.post(
        Uri.parse('https://quantapixel.in/realestate/api/storeChat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _messageController.clear();
        _fetchChatHistory();

        // Auto-scroll to the latest message
        Future.delayed(Duration(milliseconds: 500), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chat with ${widget.receiverId}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? Center(child: Text('No chats available'))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(10),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          bool isSender = message['sender_id'].toString() ==
                              widget.senderId;
                          return Align(
                            alignment: isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: isSender
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isSender
                                        ? Colors.blueAccent
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: isSender
                                          ? Radius.circular(12)
                                          : Radius.circular(0),
                                      bottomRight: isSender
                                          ? Radius.circular(0)
                                          : Radius.circular(12),
                                    ),
                                  ),
                                  constraints: BoxConstraints(maxWidth: 250),
                                  child: Text(
                                    message['message'] ?? '',
                                    style: TextStyle(
                                      color: isSender
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    _formatTimestamp(message['created_at']),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
