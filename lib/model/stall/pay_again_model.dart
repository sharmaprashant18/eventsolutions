class PayAgainModel {
  final BookingBusinessInfo businessInfo;
  final BookingContactInfo contactInfo;
  final String eventId;
  final String eventName;
  List<BookingStallInfo> stallInfo;

  final String userId;
  final bool isHold;
  final double totalAmount;
  final double pendingAmount;
  final String paymentStatus;
  List<String> paymentProof;
  List<BookingPayments> payments;
  final String status;
  final String bookingId;
  final String bookingCancelReason;

  PayAgainModel({
    required this.businessInfo,
    required this.contactInfo,
    required this.eventId,
    required this.eventName,
    required this.stallInfo,
    required this.userId,
    required this.isHold,
    required this.totalAmount,
    required this.pendingAmount,
    required this.paymentStatus,
    required this.paymentProof,
    required this.payments,
    required this.status,
    required this.bookingId,
    required this.bookingCancelReason,
  });

  factory PayAgainModel.fromJson(Map<String, dynamic> json) {
    return PayAgainModel(
      businessInfo: BookingBusinessInfo.fromJson(json['businessInfo']),
      contactInfo: BookingContactInfo.fromJson(json['contactPerson']),
      eventId: json['eventId'] ?? '',
      eventName: json['eventName'] ?? '',
      stallInfo: (json['stallInfo'] as List?)
              ?.map((e) => BookingStallInfo.fromJson(e))
              .toList() ??
          [],
      userId: json['userId'] ?? '',
      isHold: json['isHold'] ?? false,
      // CHANGED: Safe conversion from dynamic to double
      totalAmount: _toDouble(json['totalAmount']),
      pendingAmount:
          _toDouble(json['pendingAmount']), // CHANGED: Safe double conversion
      paymentStatus: json['paymentStatus'] ?? '',
      paymentProof: List<String>.from(json['paymentProof'] ?? []),
      payments: (json['payments'] as List?)
              ?.map((e) => BookingPayments.fromJson(e))
              .toList() ??
          [],
      status: json['status'] ?? '',
      bookingId: json['bookingId'] ?? '',
      bookingCancelReason: json['bookingCancelReason'] ?? '',
    );
  }

  // ADDED: Helper method to safely convert dynamic values to double
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'businessInfo': businessInfo.toJson(),
      'contactPerson': contactInfo.toJson(),
      'eventId': eventId,
      'eventName': eventName,
      'stallInfo': stallInfo.map((e) => e.toJson()).toList(),
      'userId': userId,
      'isHold': isHold,
      'totalAmount': totalAmount,
      'pendingAmount': pendingAmount,
      'paymentStatus': paymentStatus,
      'paymentProof': paymentProof,
      'payments': payments.map((e) => e.toJson()).toList(),
      'status': status,
      'bookingId': bookingId,
      'bookingCancelReason': bookingCancelReason,
    };
  }
}

class BookingBusinessInfo {
  final String name;
  final String phone;
  final String email;

  BookingBusinessInfo({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory BookingBusinessInfo.fromJson(Map<String, dynamic> json) {
    return BookingBusinessInfo(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}

class BookingContactInfo {
  final String name;
  final String phone;
  final String email;

  BookingContactInfo({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory BookingContactInfo.fromJson(Map<String, dynamic> json) {
    return BookingContactInfo(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}

class BookingStallInfo {
  final String stallType;
  final String stallId;
  final double rate;
  final double sizeInSqFt;
  final String? stallName;
  BookingStallInfo({
    required this.stallType,
    required this.stallId,
    required this.rate,
    required this.sizeInSqFt,
    this.stallName,
  });

  factory BookingStallInfo.fromJson(Map<String, dynamic> json) {
    return BookingStallInfo(
      stallType: json['stallType'] ?? '',
      stallId: json['stallId'] ?? '',
      rate: _toDouble(json['rate']),
      sizeInSqFt: _toDouble(json['sizeInSqFt']),
      stallName: json['stallName'],
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'stallType': stallType,
      'stallId': stallId,
      'rate': rate,
      'sizeInSqFt': sizeInSqFt,
    };

    if (stallName != null) {
      data['stallName'] = stallName;
    }

    return data;
  }
}

class BookingPayments {
  final String paymentId;
  final double amount;
  final String paymentDate;
  final String paymentMethod;
  final String status;
  final String? paymentProof;

  BookingPayments({
    required this.paymentId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.status,
    this.paymentProof,
  });

  factory BookingPayments.fromJson(Map<String, dynamic> json) {
    return BookingPayments(
      paymentId: json['paymentId'] ?? '',
      amount: _toDouble(json['amount']),
      paymentDate: json['paymentDate'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      status: json['status'] ?? '',
      paymentProof: json['paymentProof'],
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'paymentId': paymentId,
      'amount': amount,
      'paymentDate': paymentDate,
      'paymentMethod': paymentMethod,
      'status': status,
    };

    if (paymentProof != null) {
      data['paymentProof'] = paymentProof;
    }

    return data;
  }
}
