import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PendingProfilesScreen extends StatefulWidget {
  @override
  _PendingProfilesScreenState createState() => _PendingProfilesScreenState();
}

class _PendingProfilesScreenState extends State<PendingProfilesScreen> {
  List<dynamic> pendingProfiles = [];
  List<bool> isExpandedList = []; // List to track expanded state

  @override
  void initState() {
    super.initState();
    fetchPendingProfiles();
  }

  Future<void> fetchPendingProfiles() async {
    final response = await http.get(
      Uri.parse(
        'https://quantapixel.in/realestate/api/getPendingActivationProfiles',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 1) {
        setState(() {
          pendingProfiles = data['data'];
          isExpandedList = List.generate(pendingProfiles.length,
              (_) => false); // Initialize expanded state for each profile
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch pending profiles')),
      );
    }
  }

  Future<void> approveRejectProfile(int userId, int action) async {
    final response = await http.post(
      Uri.parse(
        'https://quantapixel.in/realestate/api/approveRejectActivationProfile',
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'action': action, // 1 for accept, 3 for reject
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['message'])));
      fetchPendingProfiles(); // Refresh list
    }
  }

  void handleExpansionChanged(bool expanded, int index) {
    setState(() {
      isExpandedList[index] = expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Pending Activation Requests")),
      body: RefreshIndicator(
        onRefresh: fetchPendingProfiles,
        child: pendingProfiles.isEmpty
            ? Center(
                child: Text(
                    'No Pending requests')) // Show loading spinner if no data is available
            : ListView.builder(
                itemCount: pendingProfiles.length,
                itemBuilder: (context, index) {
                  var profile = pendingProfiles[index];
                  return ProfileCard(
                    profile: profile,
                    isExpandedList: isExpandedList,
                    index: index,
                    onExpansionChanged: (expanded) =>
                        handleExpansionChanged(expanded, index),
                    approveRejectProfile: approveRejectProfile,
                  );
                },
              ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  final List<bool> isExpandedList;
  final int index;
  final ValueChanged<bool> onExpansionChanged;
  final Future<void> Function(int userId, int action) approveRejectProfile;

  ProfileCard({
    required this.profile,
    required this.isExpandedList,
    required this.index,
    required this.onExpansionChanged,
    required this.approveRejectProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(profile['profile']),
        ),
        title: Text(
          profile['name'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text("Email: ${profile['email']}",
            style: TextStyle(color: Colors.grey[600])),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: () => approveRejectProfile(profile['id'], 1), // Accept
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () => approveRejectProfile(profile['id'], 3), // Reject
            ),
          ],
        ),
        onExpansionChanged: (expanded) {
          // Update the expanded state in the list
          onExpansionChanged(expanded);
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mobile: ${profile['mobile']}',
                    style: TextStyle(fontSize: 16)),
                Text('WhatsApp: ${profile['whatsapp']}',
                    style: TextStyle(fontSize: 16)),
                Text('Email: ${profile['email']}',
                    style: TextStyle(fontSize: 16)),
                if (isExpandedList[index]) ...[
                  SizedBox(height: 8),
                  Text('Gender: ${profile['gender']}',
                      style: TextStyle(fontSize: 16)),
                  Text('DOB: ${profile['dob']}',
                      style: TextStyle(fontSize: 16)),
                  Text('Street: ${profile['street']}',
                      style: TextStyle(fontSize: 16)),
                  Text('District: ${profile['district']}',
                      style: TextStyle(fontSize: 16)),
                  Text('City: ${profile['city']}',
                      style: TextStyle(fontSize: 16)),
                  Text('State: ${profile['state']}',
                      style: TextStyle(fontSize: 16)),
                  Text('Bio: ${profile['bio']}',
                      style: TextStyle(fontSize: 16)),
                  Text(
                    'Account Status: ${profile['is_active'] == "2" ? "Inactive" : "Active"}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  Text('User ID: ${profile['id']}',
                      style: TextStyle(fontSize: 16)),
                  Text('Created At: ${profile['created_at']}',
                      style: TextStyle(fontSize: 16)),
                  Text('Updated At: ${profile['updated_at']}',
                      style: TextStyle(fontSize: 16)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
