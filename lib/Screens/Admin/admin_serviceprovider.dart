import 'package:flutter/material.dart';

class Service {
  final String name;
  final String phoneNumber;
  final String description;
  final String provider;
  final String imagePath;

  Service({
    required this.name,
    required this.phoneNumber,
    required this.description,
    required this.provider,
    required this.imagePath,
  });
}

class ServiceProvidersPage extends StatelessWidget {
  const ServiceProvidersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Service> serviceProviders = [
      Service(
        name: 'John Doe',
        phoneNumber: '123-456-7890',
        description: 'Plumber with 10+ years of experience.',
        provider: 'Plumbing',
        imagePath: 'assets/placeholder.png',
      ),
      Service(
        name: 'Jane Smith',
        phoneNumber: '987-654-3210',
        description: 'Painter specializing in residential painting.',
        provider: 'Painting',
        imagePath: 'assets/placeholder.png',
      ),
      Service(
        name: 'Mike Johnson',
        phoneNumber: '555-888-9999',
        description: 'Electrician with expertise in home wiring.',
        provider: 'Electrical',
        imagePath: 'assets/placeholder.png',
      ),
    ];

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Service Providers',
      //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //   ),
      //   backgroundColor: Colors.teal,
      //   centerTitle: true,
      // ),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0, // Removes the shadow
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new, // iOS-style back icon
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back when tapped
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.design_services,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              "Service Providers",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: ListView.builder(
          itemCount: serviceProviders.length,
          itemBuilder: (context, index) {
            final service = serviceProviders[index];
            return Card(
              elevation: 6,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            service.imagePath,
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.width * 0.2,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.business,
                                      size: 16, color: Colors.teal),
                                  const SizedBox(width: 5),
                                  Text(
                                    service.provider,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.phone,
                                      size: 16, color: Colors.green),
                                  const SizedBox(width: 5),
                                  Text(
                                    service.phoneNumber,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.info_outline,
                                      size: 16, color: Colors.orange),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      service.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Accept action
                          },
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Reject action
                          },
                          icon: const Icon(Icons.close, size: 18),
                          label: const Text('Reject'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
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
