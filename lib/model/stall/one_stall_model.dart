// class StallModelById {
//   final String eventId;
//   final String name;
//   final String expiryDate;
//   final String status;
//   final String stallId;
//   final String size;
//   final String stallTypeName;
//   final int price;
//   final int sizeInSqFt;
//   final String location;
//   List<String> amenities;
//   final int upchargeInPercent;

//   StallModelById({
//     required this.eventId,
//     required this.name,
//     required this.expiryDate,
//     required this.status,
//     required this.stallId,
//     required this.size,
//     required this.stallTypeName,
//     required this.price,
//     required this.sizeInSqFt,
//     required this.location,
//     required this.amenities,
//     required this.upchargeInPercent,
//   });

//   factory StallModelById.fromJson(Map<String, dynamic> json) {
//     return StallModelById(
//       eventId: json['eventId'] ?? '',
//       name: json['name'] ?? '',
//       expiryDate: json['expiryDate'] ?? '',
//       status: json['status'] ?? '',
//       stallId: json['stallId'] ?? '',
//       size: json['size'] ?? '',
//       stallTypeName: json['stallTypeName'] ?? '',
//       price: json['rate'] ?? '',
//       location: json['location'] ?? '',
//       sizeInSqFt: json['sizeInSqFt'] ?? '',
//       amenities: List<String>.from(json['amenities']),
//       upchargeInPercent: json['upchargeInPercent'] ?? '',
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'eventId': eventId,
//       'name': name,
//       'expiryDate': expiryDate,
//       'status': status,
//       'stallId': stallId,
//       'size': size,
//       'sizeInSqFt': sizeInSqFt,
//       'stallTypeName': stallTypeName,
//       'rate': price,
//       'location': location,
//       'amenities': amenities,
//       'upchargeInPercent': upchargeInPercent,
//     };
//   }
// }


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
  final String upchargeInPercent;

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
    required this.upchargeInPercent,
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
      price: _parseToInt(json['rate']),
      location: json['location'] ?? '',
      sizeInSqFt: _parseToInt(json['sizeInSqFt']),
      amenities: List<String>.from(json['amenities'] ?? []),
      // Handle dynamic type for upchargeInPercent
      upchargeInPercent: _parseToString(json['upchargeInPercent']),
    );
  }

  // Helper method to safely parse dynamic values to String
  static String _parseToString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is int) return value.toString();
    if (value is double) return value.toString();
    return value.toString();
  }

  // Helper method to safely parse dynamic values to int
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    if (value is double) return value.toInt();
    return 0;
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
      'upchargeInPercent': upchargeInPercent,
    };
  }
}
