// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:real_estate_quantapixel/Screens/Constants/BlackContainer.dart';
// import 'package:real_estate_quantapixel/Screens/Constants/Colors.dart';

// class Resetpassword extends StatefulWidget {
//   const Resetpassword({super.key});

//   @override
//   State<Resetpassword> createState() => _ResetpasswordState();
// }

// class _ResetpasswordState extends State<Resetpassword> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.mainColor, // Light green background
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // SizedBox(height: 20),
//             Container(
//                 height: 204,
//                 width: MediaQuery.of(context).size.width * 0.6,
//                 child: Image.asset('assets/image 11.png')),
//             SizedBox(height: 20),
//             Text(
//               'Reset Password',
//               style: GoogleFonts.poppins(
//                 fontSize: 28,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black,
//               ),
//             ),
//             SizedBox(height: 5),
//             Text(
//               'Enter your new password and confirm it.',
//               style: GoogleFonts.poppins(
//                   fontSize: 14,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w400),
//             ),
//             SizedBox(height: 20),
//             CustomTextField(
//                 icon: Icons.lock, hintText: 'New Password', isPassword: true),
//             SizedBox(height: 15),
//             CustomTextField(
//                 icon: Icons.lock,
//                 hintText: 'Confirm new Password',
//                 isPassword: true),
//             SizedBox(height: 10),
//             SizedBox(height: 20),
//             _buildButton('Submit', Colors.black, Colors.white, () {
//               Navigator.pop(context);
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildButton(
//       String text, Color bgColor, Color textColor, VoidCallback onPressed,
//       {bool isOutlined = false}) {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: OutlinedButton(
//         onPressed: onPressed,
//         style: OutlinedButton.styleFrom(
//           backgroundColor: isOutlined ? Colors.transparent : bgColor,
//           side: isOutlined ? BorderSide(color: Colors.black) : BorderSide.none,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//         child: Text(
//           text,
//           style: GoogleFonts.poppins(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: textColor,
//           ),
//         ),
//       ),
//     );
//   }
// }
