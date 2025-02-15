import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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

  // Fetch users from the API
  Future<void> fetchUsers() async {
    final url = Uri.parse('https://quantapixel.in/realestate/api/get-users');
    try {
      final response = await http.get(url);
      print('API Response: ${response.body}'); // Debug the API response
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          setState(() {
            users = data['users'] ?? []; // Ensure the list is not null
            isLoading = false;
          });
        } else {
          print('No users available');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Delete user by user ID
  Future<void> deleteUser(int userId) async {
    final url = Uri.parse('https://quantapixel.in/laundry_app/api/delete-user');
    try {
      final response = await http.post(url, body: {
        'user_id': userId.toString(),
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1) {
          // Successfully deleted user
          setState(() {
            users.removeWhere(
                (user) => user['id'] == userId); // Remove user from list
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
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
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting user')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sample data for users

    return Scaffold(
      appBar: AppBar(
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        title: Row(
          children: [
            Image.asset(
              'assets/1.png',
              height: 50,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Users',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(user['name'] ?? 'N/A'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mobile: ${user['mobile'] ?? 'N/A'}'),
                    Text('Address: ${user['address'] ?? 'N/A'}'),
                    Text('Status: ${user['status'] ?? 'N/A'}'),
                    Text('Created At: ${user['created_at'] ?? 'N/A'}'),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    // Show confirmation dialog before deleting user
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete User'),
                        content:
                            Text('Are you sure you want to delete this user?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              deleteUser(user['id']); // Delete user
                              Navigator.of(context).pop();
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
