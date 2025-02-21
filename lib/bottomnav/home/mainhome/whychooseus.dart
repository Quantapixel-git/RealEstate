import 'package:flutter/material.dart';
import 'dart:async';

class WhyChooseUs extends StatefulWidget {
  @override
  _WhyChooseUsState createState() => _WhyChooseUsState();
}

class _WhyChooseUsState extends State<WhyChooseUs> {
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;

        double nextScroll = currentScroll + 180; // Scroll to next card
        if (nextScroll >= maxScroll) {
          _scrollController.animateTo(0,
              duration: Duration(seconds: 1), curve: Curves.easeInOut);
        } else {
          _scrollController.animateTo(nextScroll,
              duration: Duration(seconds: 1), curve: Curves.easeInOut);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),  color: Colors.grey[100],),
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 16),
     
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Why Choose Us?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: 1.2,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Horizontal Auto-Scrolling Features
          SizedBox(
            height: 130, // Set height for a compact and professional look
            child: ListView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              children: [
                _buildFeatureCard(
                  icon: Icons.verified_user,
                  label: 'Trusted by Thousands',
                ),
                _buildFeatureCard(
                  icon: Icons.home,
                  label: 'Wide Selection',
                ),
                _buildFeatureCard(
                  icon: Icons.support_agent,
                  label: '24/7 Support',
                ),
                _buildFeatureCard(
                  icon: Icons.currency_rupee,
                  label: 'Best Price Guarantee',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({required IconData icon, required String label}) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Icon(icon, size: 40, color: Colors.blue.shade700),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
