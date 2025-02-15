import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Screens/EstateTourHP/estateTourHP.dart';
import 'package:real_estate_quantapixel/Screens/EstateTourHP/test.dart';
import 'package:real_estate_quantapixel/Screens/HomePage/homescreen.dart';
import 'package:real_estate_quantapixel/Screens/estateShorts/estateShortsHP.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  static final List<Widget> _screens = [
    Estateshortshp(),

    EstateTourHP(),
    //RealEstateHomePage()
    Homescreen(
        // accountStatus: 1,
        ),
    // Screen for the FAB
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
              : Colors.black, // const Color.fromARGB(255, 99, 62, 210),
          elevation: 10,
          child: InkWell(
            onTap: () {
              _onButtonTapped(2); // Navigate to the FAB's screen
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
