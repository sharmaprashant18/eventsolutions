class StallModelById {
  final String eventId;
  final String name;
  final String expiryDate;
  final String status;
  final String stallId;
  final String size;
  final String stallTypeName;
  final int price;
  final int sizeInSqFt;
  final String location;
  List<String> amenities;

  StallModelById({
    required this.eventId,
    required this.name,
    required this.expiryDate,
    required this.status,
    required this.stallId,
    required this.size,
    required this.stallTypeName,
    required this.price,
    required this.sizeInSqFt,
    required this.location,
    required this.amenities,
  });

  factory StallModelById.fromJson(Map<String, dynamic> json) {
    return StallModelById(
      eventId: json['eventId'] ?? '',
      name: json['name'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      status: json['status'] ?? '',
      stallId: json['stallId'] ?? '',
      size: json['size'] ?? '',
      stallTypeName: json['stallTypeName'] ?? '',
      price: json['rate'] ?? '',
      location: json['location'] ?? '',
      sizeInSqFt: json['sizeInSqFt'] ?? '',
      amenities: List<String>.from(json['amenities']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'name': name,
      'expiryDate': expiryDate,
      'status': status,
      'stallId': stallId,
      'size': size,
      'sizeInSqFt': sizeInSqFt,
      'stallTypeName': stallTypeName,
      'rate': price,
      'location': location,
      'amenities': amenities,
    };
  }
}
