import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ChatHistoryScreen extends StatefulWidget {
  final int receiverId;
  final int propertyId;

  ChatHistoryScreen({required this.receiverId, required this.propertyId});

  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  List<dynamic> messages = [];
  bool isLoading = true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchChatHistory();
  }

  Future<void> _fetchChatHistory() async {
    try {
      final response = await http.post(
        Uri.parse('https://quantapixel.in/realestate/api/getChatHistory'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": widget.receiverId,
          "property_id": widget.propertyId,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 1) {
          setState(() {
            messages = responseData['data'];
            isLoading = false;
          });

          // Auto-scroll to latest message
          Future.delayed(Duration(milliseconds: 500), () {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('MMM d, yyyy hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat History')),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? Center(child: Text('No messages available'))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(10),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          bool isYou = message['sender_id'] == widget.receiverId;

                          return Align(
                            alignment: isYou
                                ? Alignment.centerRight // You
                                : Alignment.centerLeft, // Other
                            child: Column(
                              crossAxisAlignment: isYou
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: isYou
                                        ? Colors.blueAccent
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: isYou
                                          ? Radius.circular(12)
                                          : Radius.circular(0),
                                      bottomRight: isYou
                                          ? Radius.circular(0)
                                          : Radius.circular(12),
                                    ),
                                  ),
                                  constraints:
                                      BoxConstraints(maxWidth: 250), // Bubble size
                                  child: Text(
                                    message['message'] ?? '',
                                    style: TextStyle(
                                      color: isYou
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    formatDate(message['created_at']),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    isYou ? 'You' : 'Other', // Fixed
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: isYou
                                          ? Colors.blueAccent
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
