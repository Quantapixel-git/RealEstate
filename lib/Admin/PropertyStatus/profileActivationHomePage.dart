import 'package:flutter/material.dart';
import 'package:real_estate_quantapixel/Admin/PropertyStatus/approvedreq.dart';
import 'package:real_estate_quantapixel/Admin/PropertyStatus/pendingreq.dart';
import 'package:real_estate_quantapixel/Admin/PropertyStatus/rejectedreq.dart';

class Profileactivationhomepage extends StatefulWidget {
  const Profileactivationhomepage({super.key});

  @override
  State<Profileactivationhomepage> createState() =>
      _ProfileactivationhomepageState();
}

class _ProfileactivationhomepageState extends State<Profileactivationhomepage> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    PendingPropertiesScreen(),
    ApprovedPropertiesScreen(),
    RejectedPropertiesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
