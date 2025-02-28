import 'package:flutter/material.dart';
import 'package:real_estate_quantapixel/bottomnav/Propertydetail/propertydetail.dart';

void showPropertyDetailsBottomSheet(
    BuildContext context, PropertyDetails property) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Property Name
                  Text(
                    property.propertyName ?? "No Name", // Handle null
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    property.location ?? "Unknown Location", // Handle null
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  Divider(thickness: 1, height: 20),

                  // Property Details
                  _infoRow(Icons.price_change, "Price",
                      property.price?.toString() ?? "Price not available",
                      color: Colors.green),
                  _infoRow(
                      Icons.description,
                      "Description",
                      property.description ??
                          "No description available"), // Handle null
                  _infoRow(
                      Icons.local_offer,
                      "Amenities",
                      property.amenities ??
                          "No amenities available"), // Handle null

                  Divider(thickness: 1, height: 20),
                  Text(
                    "Contact Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  SizedBox(height: 10),
                  _infoRow(Icons.person, "Owner",
                      property.userName ?? "Unknown Owner"), // Handle null
                  _infoRow(Icons.phone, "Contact",
                      property.mobile ?? "No contact available"), // Handle null

                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _infoRow(IconData icon, String title, String value,
    {Color color = Colors.black87}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue.shade900, size: 22),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            "$title:",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: color),
            maxLines: 5,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
