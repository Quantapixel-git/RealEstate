
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blue.shade900,
      padding: EdgeInsets.all(30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '© 2025 AdShow | All Rights Reserved',
            style: TextStyle(color: Colors.blue.shade900, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
