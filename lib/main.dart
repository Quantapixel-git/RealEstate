import 'package:flutter/material.dart';
import 'package:real_estate_quantapixel/Screens/BottomnavBar.dart';
import 'package:real_estate_quantapixel/Screens/HomePage/homescreen.dart';
import 'package:real_estate_quantapixel/Screens/OnBoardingPage.dart';
import 'package:real_estate_quantapixel/Screens/estateShorts/try.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
