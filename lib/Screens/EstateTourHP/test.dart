// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Roboto',
//         primaryColor: Colors.blue,
//         hoverColor: Colors.white,
//       ),
//       home: RealEstateHomePage(),
//     );
//   }
// }

// class RealEstateHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'DreamNest',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//         ),
//         centerTitle: true,
//         elevation: 4,
//         backgroundColor: Colors.blue.shade900,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.search, color: Colors.white),
//             onPressed: () {
//               // Implement search functionality
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             HeroSection(),
//             FeaturedProperties(),
//             WhyChooseUs(),
//             CustomerTestimonials(),
//             AboutSection(),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Footer(),
//     );
//   }
// }

// class HeroSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: 350,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade900, Colors.blue.shade600],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             'Find Your Dream Property',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Explore the best properties tailored to your needs.',
//             style: TextStyle(
//               color: Colors.white70,
//               fontSize: 16,
//             ),
//           ),
//           SizedBox(height: 20),
//           ElevatedButton(
//             onPressed: () {
//               // Implement navigation to property search
//             },
//             child: Text(
//               'Get Started',
//               style: TextStyle(fontSize: 16),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.orange,
//               padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class FeaturedProperties extends StatelessWidget {
//   final List<Map<String, String>> properties = [
//     {
//       'image': 'https://via.placeholder.com/300',
//       'title': 'Luxury Villa in the City',
//       'price': '\$1,200,000',
//       'location': 'Downtown, City',
//     },
//     {
//       'image': 'https://via.placeholder.com/300',
//       'title': 'Modern Apartment',
//       'price': '\$800,000',
//       'location': 'Uptown, City',
//     },
//     {
//       'image': 'https://via.placeholder.com/300',
//       'title': 'Cozy House in Suburbs',
//       'price': '\$350,000',
//       'location': 'Suburbs, City',
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Featured Properties',
//             style: TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 16),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//               childAspectRatio: 3 / 4,
//             ),
//             itemCount: properties.length,
//             itemBuilder: (context, index) {
//               var property = properties[index];
//               return Card(
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ClipRRect(
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(15)),
//                       child: Image.network(
//                         property['image']!,
//                         height: 120,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             property['title']!,
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           Text(property['price']!),
//                           Text(property['location']!,
//                               style: TextStyle(color: Colors.grey)),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
