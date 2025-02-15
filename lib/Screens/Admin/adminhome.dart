import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Screens/Admin/ProfileActivation/profileActivationHomePage.dart';
import 'package:real_estate_quantapixel/Screens/Admin/Users/admin_users.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              'Admin Panel',
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              //Dashboard Title
              // const Text(
              //   "Welcome, Admin",
              //   style: TextStyle(
              //     fontSize: 28,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black87,
              //   ),
              // ),
              // const SizedBox(height: 8),
              // const Text(
              //   "Manage your platform efficiently",
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.grey,
              //   ),
              // ),
              //  const SizedBox(height: 30),
              //       Manage Service Providers
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profileactivationhomepage()),
                  );
                },
                child: DashboardTile(
                  title: "Profile Activation",
                  icon: Icons.business,
                  gradientColors: [Colors.teal, Colors.green],
                ),
              ),
              const SizedBox(height: 20),
              // Manage Users
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UsersPage()),
                  );
                },
                child: DashboardTile(
                  title: "Manage Users",
                  icon: Icons.people,
                  gradientColors: [Colors.orange, Colors.red],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;

  const DashboardTile({
    super.key,
    required this.title,
    required this.icon,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(
              icon,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
            size: 18,
          ),
        ],
      ),
    );
  }
}
