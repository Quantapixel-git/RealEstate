import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Admin/Users/chatlistadmin.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('https://quantapixel.in/realestate/api/get-users');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          setState(() {
            users = data['users'] ?? [];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteUser(int userId) async {
    final url = Uri.parse('https://quantapixel.in/realestate/api/delete-user');
    try {
      final response = await http.post(url, body: {
        'user_id': userId.toString(),
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          setState(() {
            users.removeWhere((user) => user['id'] == userId);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User  deleted successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete user')),
          );
        }
      } else {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting user')),
      );
    }
  }

  Future<void> updateUserStatus(int userId, int status) async {
    final url =
        Uri.parse('https://quantapixel.in/realestate/api/updateUserStatus');
    try {
      final response = await http.post(url, body: {
        'user_id': userId.toString(),
        'status': status.toString(),
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          setState(() {
            // Update the user's status in the list
            final userIndex = users.indexWhere((user) => user['id'] == userId);
            if (userIndex != -1) {
              users[userIndex]['status'] = status; // Update the status
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(status == 1
                    ? 'User  unblocked successfully'
                    : 'User  blocked successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update user status')),
          );
        }
      } else {
        throw Exception('Failed to update user status');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating user status')),
      );
    }
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Column(
            children: [
              Text('Users',
                  style: GoogleFonts.poppins(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Pull down to refresh',
                  style: GoogleFonts.poppins(fontSize: 12)),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchUsers,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${user['name'] ?? 'N/A'}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text('User  ID: ${user['id'] ?? 'N/A'}',
                                  style: GoogleFonts.poppins(fontSize: 14)),
                              Text('Mobile: ${user['mobile'] ?? 'N/A'}',
                                  style: GoogleFonts.poppins(fontSize: 14)),
                              Text(
                                  'Status: ${user['status'] == 1 ? 'Active' : 'Blocked'}',
                                  style: GoogleFonts.poppins(fontSize: 14)),
                              Text(
                                  'Created At: ${formatDate(user['created_at'] ?? 'N/A')}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12, color: Colors.grey)),
                              SizedBox(height: 8),
                                ElevatedButton(
                            onPressed: () {
                              // Navigate to ChatListPage with the user ID
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatListPage(userId: user['id']),
                                ),
                              );
                            },
                            child: Text('View Chat'),
                          ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  user['status'] == 1
                                      ? Icons.check_circle
                                      : Icons.block,
                                  color: user['status'] == 1
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                onPressed: () {
                                  // Toggle user status
                                  int newStatus = user['status'] == 1 ? 2 : 1;
                                  updateUserStatus(user['id'], newStatus);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete User',
                                          style: TextStyle()),
                                      content: Text(
                                          'Are you sure you want to delete this user?',
                                          style: GoogleFonts.poppins()),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('Cancel',
                                              style: GoogleFonts.poppins()),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteUser(user['id']);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Confirm',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
