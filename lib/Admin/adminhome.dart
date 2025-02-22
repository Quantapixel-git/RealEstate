import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Admin/AdminLogin.dart';
import 'package:real_estate_quantapixel/Admin/PropertyStatus/profileActivationHomePage.dart';
import 'package:real_estate_quantapixel/Admin/Users/adminUsers.dart';
import 'package:real_estate_quantapixel/Admin/adminchangepassword.dart';
import 'package:real_estate_quantapixel/Admin/query/adminquery.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  Widget _currentScreen = const AdminDashboard();

  void _navigateToPage(Widget page) {
    setState(() {
      _currentScreen = page;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(title: 'Admin Panel'),
      drawer: AdminDrawer(onNavigate: _navigateToPage),
      body: _currentScreen,
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome, Admin",
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Manage the system efficiently",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 20),
          Image.asset('assets/1.png', width: 200),
        ],
      ),
    );
  }
}

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AdminAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset('assets/1.png', height: 40),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 5,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AdminDrawer extends StatelessWidget {
  final Function(Widget) onNavigate;
  const AdminDrawer({super.key, required this.onNavigate});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Adminlogin()),
                (Route<dynamic> route) => false,
              );
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue.shade900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Text(
                  "Hello, Admin",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Manage the system efficiently",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          buildDrawerItem(
            icon: Icons.dashboard,
            title: "Dashboard",
            context: context,
            page: const AdminDashboard(),
          ),
          buildDrawerItem(
            icon: Icons.business,
            title: "Property Approve",
            context: context,
            page: const Profileactivationhomepage(),
          ),
          buildDrawerItem(
            icon: Icons.people,
            title: "Manage Users",
            context: context,
            page: UsersPage(),
          ),
          buildDrawerItem(
            icon: Icons.question_answer,
            title: "Queries",
            context: context,
            page: AdminQueryScreen(),
          ),
          buildDrawerItem(
            icon: Icons.question_answer,
            title: "Change Password",
            context: context,
            page: ChangePasswordScreen(),
          ),
          const Spacer(),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text("Logout",
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.red)),
              onTap: () => _logout(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItem({
    required IconData icon,
    required String title,
    required BuildContext context,
    required Widget page,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue.shade900),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
      onTap: () => onNavigate(page),
    );
  }
}
