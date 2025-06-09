class MultipleStallBookingModel {
  final String eventId;
  final String eventName;
  final List<StallInfo> stallInfo;
  // final String stallId;
  final String userId;
  final bool isHold;
  // final String? holdExpiry;
  final double totalAmount;
  final double pendingAmount;
  final String paymentStatus;
  final List<String> paymentProof;
  final List<MultiplePaymentInfo> payments;
  final String status;
  final MultipleBusinessInfo businessInfo;
  final MultipleContactPerson contactPerson;
  final String bookingId;
  final String createdAt;
  final String updatedAt;

  MultipleStallBookingModel({
    required this.eventId,
    required this.eventName,
    required this.stallInfo,
    // required this.stallId,
    required this.userId,
    required this.isHold,
    // required this.holdExpiry,
    required this.totalAmount,
    required this.pendingAmount,
    required this.paymentStatus,
    required this.paymentProof,
    required this.payments,
    required this.status,
    required this.businessInfo,
    required this.contactPerson,
    required this.bookingId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MultipleStallBookingModel.fromJson(Map<String, dynamic> json) {
    return MultipleStallBookingModel(
      eventId: json['eventId'],
      eventName: json['eventName'],
      stallInfo: (json['stallInfo'] as List)
          .map((e) => StallInfo.fromJson(e))
          .toList(),
      // stallId: json['stallId'] ?? '',
      userId: json['userId'],
      isHold: json['isHold'],
      // holdExpiry: json['holdExpiry'],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      pendingAmount: (json['pendingAmount'] ?? 0).toDouble(),
      paymentStatus: json['paymentStatus'],
      paymentProof: List<String>.from(json['paymentProof'] ?? []),
      payments: (json['payments'] as List)
          .map((e) => MultiplePaymentInfo.fromJson(e))
          .toList(),
      status: json['status'],
      businessInfo: MultipleBusinessInfo.fromJson(json['businessInfo']),
      contactPerson: MultipleContactPerson.fromJson(json['contactPerson']),
      bookingId: json['bookingId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventName': eventName,
      'stallInfo': stallInfo.map((e) => e.toJson()).toList(),
      // 'stallId': stallId,
      'userId': userId,
      'isHold': isHold,
      // 'holdExpiry': holdExpiry,
      'totalAmount': totalAmount,
      'pendingAmount': pendingAmount,
      'paymentStatus': paymentStatus,
      'paymentProof': paymentProof,
      'payments': payments.map((e) => e.toJson()).toList(),
      'status': status,
      'businessInfo': businessInfo.toJson(),
      'contactPerson': contactPerson.toJson(),
      'bookingId': bookingId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class StallInfo {
  final String stallName;
  final String stallType;
  final String stallId;
  final int rate;
  final int sizeInSqFt;
  final int upchargeInPercent;

  StallInfo({
    required this.stallName,
    required this.stallType,
    required this.stallId,
    required this.rate,
    required this.sizeInSqFt,
    required this.upchargeInPercent,
  });

  factory StallInfo.fromJson(Map<String, dynamic> json) {
    return StallInfo(
      stallName: json['stallName'],
      stallType: json['stallType'],
      stallId: json['stallId'],
      rate: json['rate'] ?? 0,
      sizeInSqFt: json['sizeInSqFt'] ?? 0,
      upchargeInPercent: json['upchargeInPercent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stallName': stallName,
      'stallType': stallType,
      'stallId': stallId,
      'rate': rate,
      'sizeInSqFt': sizeInSqFt,
      'upchargeInPercent': upchargeInPercent,
    };
  }
}

class MultiplePaymentInfo {
  final String paymentId;
  final double amount;
  final String paymentDate;
  final String paymentProof;
  final String paymentMethod;
  final String status;

  MultiplePaymentInfo({
    required this.paymentId,
    required this.amount,
    required this.paymentDate,
    required this.paymentProof,
    required this.paymentMethod,
    required this.status,
  });

  factory MultiplePaymentInfo.fromJson(Map<String, dynamic> json) {
    return MultiplePaymentInfo(
      paymentId: json['paymentId'],
      amount: (json['amount'] ?? 0).toDouble(),
      paymentDate: json['paymentDate'],
      paymentProof: json['paymentProof'] ?? '',
      paymentMethod: json['paymentMethod'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'amount': amount,
      'paymentDate': paymentDate,
      'paymentProof': paymentProof,
      'paymentMethod': paymentMethod,
      'status': status,
    };
  }
}

class MultipleBusinessInfo {
  final String businessName;
  final String businessPhone;
  final String businessEmail;

  MultipleBusinessInfo({
    required this.businessName,
    required this.businessPhone,
    required this.businessEmail,
  });

  factory MultipleBusinessInfo.fromJson(Map<String, dynamic> json) {
    return MultipleBusinessInfo(
      businessName: json['name'] ?? '',
      businessPhone: json['phone'] ?? '',
      businessEmail: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': businessName,
      'phone': businessPhone,
      'email': businessEmail,
    };
  }
}

class MultipleContactPerson {
  final String name;
  final String phone;
  final String email;

  MultipleContactPerson({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory MultipleContactPerson.fromJson(Map<String, dynamic> json) {
    return MultipleContactPerson(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}
