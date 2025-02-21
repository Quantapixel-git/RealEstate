import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/bottomnav/videos/estateTourHP.dart';
import 'package:real_estate_quantapixel/bottomnav/home/mainhome/homescreen.dart';
import 'package:real_estate_quantapixel/bottomnav/reels/estateShortsHP.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 2;
  static final List<Widget> _screens = [
    Estateshortshp(),
    EstateTourHP(),
    Homescreen(),
  ];

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavBarItem(Icons.camera_roll, 'Estate Shorts', 0),
            const SizedBox(width: 10),
            buildNavBarItem(Icons.live_tv, 'Estate Tour', 1),
          ],
        ),
      ),
      floatingActionButton: ClipOval(
        child: Material(
          color: _selectedIndex == 2
              ? const Color.fromARGB(255, 255, 0, 0)
              : Colors.black,
          elevation: 10,
          child: InkWell(
            onTap: () {
              _onButtonTapped(2);
            },
            child: const SizedBox(
              height: 65,
              width: 65,
              child: Icon(
                Icons.home,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildNavBarItem(IconData icon, String label, int index) {
    return InkWell(
      onTap: () {
        _onButtonTapped(index);
      },
      child: Column(
        children: [
          Icon(
            icon,
            color: _selectedIndex == index
                ? const Color.fromARGB(255, 255, 0, 0)
                : Colors.black,
          ),
          Text(
            label,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
