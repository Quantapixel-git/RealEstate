import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:real_estate_quantapixel/Screens/HomePage/homescreen.dart';
import 'package:real_estate_quantapixel/Screens/HomePage/homescreen1.dart';
import 'package:real_estate_quantapixel/Screens/HomePage/savedvideos.dart';

class Drawerwidgett extends StatefulWidget {
  const Drawerwidgett({super.key});

  @override
  State<Drawerwidgett> createState() => _DrawerwidgetState();
}

class _DrawerwidgetState extends State<Drawerwidgett> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      //  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      child: Column(
        children: <Widget>[
          // Profile Section
          UserAccountsDrawerHeader(
            accountName: Text("Sheersh Tehri"),
            accountEmail: Text("sheershtehri@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://www.w3schools.com/w3images/avatar2.png', // Replace with a real image URL or asset
              ),
            ),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 70, 130, 180),
            ),
          ),

          // Drawer Items
          InkWell(
            child: ListTile(
              leading: Icon(CupertinoIcons.bookmark_fill),
              title: Text(
                'Saved',
                style: TextStyle(fontSize: 17),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SavedPropertiesScreen()));
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble_outline),
            title: Text(
              'Your Shorts',
              style: TextStyle(fontSize: 17),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => YourProfile(
                            accountStatus: 1,
                          )));
            },
          ),
          ListTile(
            leading: Icon(CupertinoIcons.doc_on_clipboard),
            title: Text(
              'Your Profile',
              style: TextStyle(fontSize: 17),
            ),
            onTap: () {
              // Handle navigation here
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => Homescreen()));
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => Homescreen()));
            },
          ),
        ],
      ),
    );
  }
}
