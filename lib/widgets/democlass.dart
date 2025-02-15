class EstateTours {
  final String url;
  final String Name;
  final String Location;
  final String price;
  final String description;

  EstateTours(
      {required this.url,
      required this.Name,
      required this.Location,
      required this.price,
      required this.description});
}

List<EstateTours> estateList = [
  EstateTours(
    url: "assets/video4.mp4",
    Name: "Cozy Cottage",
    Location: "Asheville, NC",
    price: "\$3500",
    description:
        "A charming 3-bedroom cottage located in a peaceful neighborhood surrounded by greenery.",
  ),
  EstateTours(
    url: "assets/video3.mp4",
    Name: "Urban Apartment",
    Location: "Manhattan, NY",
    price: "\$1,200",
    description:
        "A sleek 2-bedroom apartment in the heart of the city, close to major attractions and amenities.",
  ),
  EstateTours(
    url: "assets/video5.mp4",
    Name: "Beachfront Mansion",
    Location: "Miami, FL",
    price: "\$8,500",
    description:
        "A magnificent 7-bedroom mansion with private beach access, perfect for luxury living.",
  ),
  EstateTours(
    url: "assets/video2.mp4",
    Name: "Modern Villa",
    Location: "Beverly Hills, CA",
    price: "\$5,000",
    description:
        "A luxurious modern villa with 5 bedrooms, a swimming pool, and stunning city views.",
  ),
];
