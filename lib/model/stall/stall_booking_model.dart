class StallBookingModel {
  final String eventId;
  final String stallId;
  final bool isHold;
  final String paymentStatus;
  final List<String> paymentProof;
  final String status;
  final BusinessInfo businessInfo;
  final ContactPerson contactPerson;
  final String bookingId;
  StallBookingModel(
      {required this.eventId,
      required this.stallId,
      required this.isHold,
      required this.paymentStatus,
      required this.paymentProof,
      required this.status,
      required this.businessInfo,
      required this.contactPerson,
      required this.bookingId});
  factory StallBookingModel.fromJson(Map<String, dynamic> json) {
    return StallBookingModel(
        eventId: json['eventId'],
        stallId: json['stallId'],
        isHold: json['isHold'],
        paymentStatus: json['paymentStatus'],
        paymentProof: List<String>.from(json['paymentProof'] ?? []),
        status: json['status'],
        businessInfo: BusinessInfo.fromJson(
          json['businessInfo'],
        ),
        contactPerson: ContactPerson.fromJson(json['contactPerson']),
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
      'businessInfo': businessInfo.toJson(),
      'contactPerson': contactPerson.toJson(),
      'bookingId': bookingId
    };
  }
}

class BusinessInfo {
  final String businessName;
  final String businessPhone;
  final String businessEmail;
  BusinessInfo(
      {required this.businessName,
      required this.businessPhone,
      required this.businessEmail});
  factory BusinessInfo.fromJson(Map<String, dynamic> json) {
    return BusinessInfo(
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

class ContactPerson {
  final String name;
  final String phone;
  final String email;
  ContactPerson({required this.name, required this.phone, required this.email});
  factory ContactPerson.fromJson(Map<String, dynamic> json) {
    return ContactPerson(
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone, 'email': email};
  }
}
