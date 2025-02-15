import 'package:flutter/material.dart';
import 'package:real_estate_quantapixel/Screens/estateShorts/savevideoservice.dart';

class SavedPropertiesScreen extends StatefulWidget {
  @override
  _SavedPropertiesScreenState createState() => _SavedPropertiesScreenState();
}

class _SavedPropertiesScreenState extends State<SavedPropertiesScreen> {
  final VideoService apiService = VideoService();
  List<dynamic> properties = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  void fetchProperties() async {
    try {
      final data = await apiService.getTopFiveSavedProperties(75);

      // Ensure the response is a List
      if (data is List) {
        setState(() {
          properties = data;
          isLoading = false;
        });
      } else {
        throw "Invalid data format. Expected a list.";
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Failed to load properties. Please try again.";
      });
      print("Error fetching properties: $e");
    }
  }

  void removeProperty(dynamic propertyId) async {
    int id = int.tryParse(propertyId.toString()) ?? 0;
    if (id == 0) return; // Prevent invalid ID from being sent

    bool success = await apiService.removeSavedVideo(75, id);
    if (success) {
      setState(() {
        properties.removeWhere(
            (property) => int.tryParse(property["id"].toString()) == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Properties"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple))
          : errorMessage != null
              ? Center(
                  child: Text(errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16)))
              : Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.0,
                      mainAxisSpacing: 12.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final property = properties[index];
                      int propertyId =
                          int.tryParse(property["id"].toString()) ?? 0;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PropertyDetailScreen(property: property),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 6,
                          shadowColor: Colors.black54,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Property Image
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Image.network(
                                      property["thumbnail_url"] ?? "",
                                      height: 130,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 130,
                                          color: Colors.grey[300],
                                          child: const Icon(Icons.broken_image,
                                              size: 50, color: Colors.grey),
                                        );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white70,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            removeProperty(propertyId),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      property["property_name"] ??
                                          "Unnamed Property",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on,
                                            color: Colors.grey, size: 14),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            property["location"] ??
                                                "Unknown Location",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "\$${property["price"] ?? "N/A"}",
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class PropertyDetailScreen extends StatelessWidget {
  final dynamic property;

  const PropertyDetailScreen({Key? key, required this.property})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property["property_name"] ?? "Property Details"),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  property["thumbnail_url"] ?? "",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image,
                          size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                property["property_name"] ?? "Unnamed Property",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    property["location"] ?? "Unknown Location",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "\$${property["price"] ?? "N/A"}",
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                property["description"] ?? "No description available.",
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
