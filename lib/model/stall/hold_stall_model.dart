class HoldstallModel {
  final String eventId;
  final String stallId;
  final String userId;
  final String holdExpiry;
  final int totalAmount;
  final bool isHold;
  final String paymentStatus;
  final List<String> paymentProof;
  final String status;
  final HoldBusinessInfo businessInfo;
  final HoldContactPerson contactPerson;
  final String bookingId;
  HoldstallModel(
      {required this.eventId,
      required this.stallId,
      required this.userId,
      required this.holdExpiry,
      required this.totalAmount,
      required this.isHold,
      required this.paymentStatus,
      required this.paymentProof,
      required this.status,
      required this.businessInfo,
      required this.contactPerson,
      required this.bookingId});
  factory HoldstallModel.fromJson(Map<String, dynamic> json) {
    return HoldstallModel(
        eventId: json['eventId'],
        stallId: json['stallId'],
        userId: json['userId'],
        holdExpiry: json['holdExpiry'],
        totalAmount: json['totalAmount'],
        isHold: json['isHold'],
        paymentStatus: json['paymentStatus'],
        paymentProof: List<String>.from(json['paymentProof'] ?? []),
        status: json['status'],
        businessInfo: HoldBusinessInfo.fromJson(
          json['businessInfo'],
        ),
        contactPerson: HoldContactPerson.fromJson(json['contactPerson']),
        bookingId: json['bookingId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'stallId': stallId,
      'isHold': isHold,
      'paymentStatus': paymentStatus,
      'paymentProof': paymentProof,
      'status': status,
      'userId': userId,
      'holdExpiry': holdExpiry,
      'totalAmount': totalAmount,
      'businessInfo': businessInfo.toJson(),
      'contactPerson': contactPerson.toJson(),
      'bookingId': bookingId
    };
  }
}

class HoldBusinessInfo {
  final String businessName;
  final String businessPhone;
  final String businessEmail;
  HoldBusinessInfo(
      {required this.businessName,
      required this.businessPhone,
      required this.businessEmail});
  factory HoldBusinessInfo.fromJson(Map<String, dynamic> json) {
    return HoldBusinessInfo(
        businessName: json['name'] ?? '',
        businessPhone: json['phone'] ?? '',
        businessEmail: json['email'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'name': businessName,
      'phone': businessPhone,
      'email': businessEmail
    };
  }
}

class HoldContactPerson {
  final String name;
  final String phone;
  final String email;
  HoldContactPerson(
      {required this.name, required this.phone, required this.email});
  factory HoldContactPerson.fromJson(Map<String, dynamic> json) {
    return HoldContactPerson(
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone, 'email': email};
  }
}
