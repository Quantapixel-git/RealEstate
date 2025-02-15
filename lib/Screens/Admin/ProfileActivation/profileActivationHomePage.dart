import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Screens/Admin/ProfileActivation/approvedreq.dart';
import 'package:real_estate_quantapixel/Screens/Admin/ProfileActivation/pendingreq.dart';
import 'package:real_estate_quantapixel/Screens/Admin/ProfileActivation/rejectedreq.dart';
import 'package:real_estate_quantapixel/Screens/Admin/adminhome.dart';

class Profileactivationhomepage extends StatefulWidget {
  const Profileactivationhomepage({super.key});

  @override
  State<Profileactivationhomepage> createState() =>
      _ProfileactivationhomepageState();
}

class _ProfileactivationhomepageState extends State<Profileactivationhomepage> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    PendingProfilesScreen(),
    ApprovedProfilesScreen(),
    RejectedProfilesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              'Sellers Activation',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 5,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Pending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Approved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Rejected',
          ),
        ],
      ),
    );
  }
}
