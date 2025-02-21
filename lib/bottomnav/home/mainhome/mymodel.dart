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
      id: json['id'],
      userName: json['user_name'],
      propertyName: json['property_name'],
      thumbnailUrl: json['thumbnail_url'],
      location: json['location'],
      price: json['price'],
      description: json['description'],
    );
  }
}