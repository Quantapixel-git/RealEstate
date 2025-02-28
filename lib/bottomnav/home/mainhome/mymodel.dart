class Reel {
  final int id;
  final String userName;
  final String propertyName;
  final String thumbnailUrl;
  final String location;
  final String price;
  final String description;

  Reel({
    required this.id,
    required this.userName,
    required this.propertyName,
    required this.thumbnailUrl,
    required this.location,
    required this.price,
    required this.description,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      userName: json['user_name'] ?? 'Unknown',
      propertyName: json['property_name'] ?? 'Unnamed Property',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      location: json['location'] ?? 'Unknown Location',
      price: json['price']?.toString() ?? '0',
      description: json['description'] ?? 'No description available',
    );
  }
}
