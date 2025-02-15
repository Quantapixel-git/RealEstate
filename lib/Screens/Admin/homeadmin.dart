import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:real_estate_quantapixel/Screens/Auth/AdminLogin.dart';
import 'package:real_estate_quantapixel/Screens/Constants/Colors.dart';
import 'package:real_estate_quantapixel/Screens/shared_pref.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFFFF8F8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _appBarView(),
            SizedBox(height: screenHeight * 0.02),

            // Options Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  _buildRowOptions(
                    context: context,
                    options: [
                      {
                        'label': 'Categories',
                        'icon': Icons.category,
                        'page': Scaffold //CategoryPage()
                      },
                      {
                        'label': 'Products',
                        'icon': Icons.production_quantity_limits,
                        'page': Scaffold //ProductListPage()
                      },
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildRowOptions(
                    context: context,
                    options: [
                      {
                        'label': 'Image Slider 1',
                        'icon': Icons.image,
                        'page': Scaffold //Imagesliderhome()
                      },
                      {
                        'label': 'Image Slider 2',
                        'icon': Icons.image_search,
                        'page': Scaffold //Imagesliderhome2()
                      },
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildRowOptions(
                    context: context,
                    options: [
                      {
                        'label': 'Orders',
                        'icon': Icons.receipt,
                        'page': Scaffold //OrdersScreen()
                      },
                      {
                        'label': 'Users',
                        'icon': Icons.supervised_user_circle,
                        'page': Scaffold //UsersPage()
                      },
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildRowOptions(
                    context: context,
                    options: [
                      {
                        'label': 'Need Help ?',
                        'icon': Icons.help_outline,
                        'page': Scaffold //NeedHelpAdminPage()
                      },
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowOptions(
      {required BuildContext context,
      required List<Map<String, dynamic>> options}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: options.map((option) {
        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => option['page']),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            height: 120,
            width: MediaQuery.of(context).size.width * 0.42,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 249, 21, 21),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(option['icon'], size: 30, color: AppColors.mainColor),
                const SizedBox(height: 10),
                Text(
                  option['label'],
                  style: GoogleFonts.exo(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mainColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _appBarView() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 249, 21, 21),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 50.0, 15.0, 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Admin Adshow',
                    style: GoogleFonts.notoSerif(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '(Admin Panel)',
                    style: GoogleFonts.exo(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white, size: 28),
              onPressed: () {
                SharedPref().setAdminLogin(false);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Adminlogin()),
                  (Route<dynamic> route) => false, // Remove all routes
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
