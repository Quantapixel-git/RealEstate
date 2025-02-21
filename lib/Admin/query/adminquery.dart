import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class AdminQueryScreen extends StatefulWidget {
  @override
  _AdminQueryScreenState createState() => _AdminQueryScreenState();
}

class _AdminQueryScreenState extends State<AdminQueryScreen> {
  List<dynamic> contactRequests = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse('https://quantapixel.in/realestate/api/getAllContacts'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 1) {
          setState(() {
            contactRequests = responseData['data'];
            isLoading = false;
          });
        } else {
          throw Exception("Failed to load contacts");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  Future<void> deleteContact(int contactId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://quantapixel.in/realestate/api/deleteContactRequests'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"contact_id": contactId}),
      );

      final responseData = json.decode(response.body);
      if (responseData['status'] == 1) {
        setState(() {
          contactRequests.removeWhere((contact) => contact['id'] == contactId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Contact deleted successfully!")),
        );
      } else {
        throw Exception("Failed to delete contact");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting contact. Try again!")),
      );
    }
  }

  void confirmDelete(int contactId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Contact"),
        content: Text("Are you sure you want to delete this contact?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteContact(contactId);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Column(
          children: [
            Text("Admin Queries",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
              "Pull down to refresh",
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(
                  child: Text(
                    "Failed to load data. Try again later!",
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchContacts,
                  child: contactRequests.isEmpty
                      ? Center(
                          child: Text(
                            "No contact requests found.",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: contactRequests.length,
                          itemBuilder: (context, index) {
                            final contact = contactRequests[index];
                            return Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name: ${contact['name']}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Email: ${contact['email']}",
                                          style:
                                              GoogleFonts.poppins(fontSize: 14),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Mobile: ${contact['mobile']}",
                                          style:
                                              GoogleFonts.poppins(fontSize: 14),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Message: ${contact['message']}",
                                          style:
                                              GoogleFonts.poppins(fontSize: 14),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Received At: ${contact['created_at']}",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                    IconButton(
                                      icon:
                                          Icon(Icons.delete, color: Colors.red),
                                      onPressed: () =>
                                          confirmDelete(contact['id']),
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
