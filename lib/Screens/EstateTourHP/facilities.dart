import 'package:flutter/material.dart';

class Facilities extends StatelessWidget {
  const Facilities({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 225, 225, 225),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Icon(Icons.bed),
                  Text('Bed'),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 225, 225, 225),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Icon(Icons.bed),
                  Text('Kitchen'),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 225, 225, 225),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Icon(Icons.bed),
                  Text('Bath'),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 225, 225, 225),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Icon(Icons.bed),
                  Text('Dining'),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 225, 225, 225),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Icon(Icons.bed),
                  Text('Television'),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 225, 225, 225),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Icon(Icons.bed),
                  Text('Bed'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
