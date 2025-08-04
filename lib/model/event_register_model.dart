import 'dart:developer';

class EventRegisterModel {
  final bool success;
  final String message;
  final RegistrationData data;
  final String? error;
  final String timestamp;

  EventRegisterModel({
    required this.success,
    required this.message,
    required this.data,
    this.error,
    required this.timestamp,
  });

  factory EventRegisterModel.fromJson(Map<String, dynamic> json) {
    return EventRegisterModel(
      success: json['success'],
      message: json['message'],
      data: RegistrationData.fromJson(json['data']),
      error: json['error'],
      timestamp: json['timestamp'],
    );
  }
}

class RegistrationData {
  final String eventId;
  final String name;
  final String eventName;
  final String userId;
  final String number;
  final String email;
  final TicketInfo ticketInfo;
  final String? paymentScreenshot;
  final String status;
  final String note;
  final String id;
  final String ticketId;
  final String submittedAt;
  final String updatedAt;

  RegistrationData({
    required this.eventId,
    required this.name,
    required this.eventName,
    required this.userId,
    required this.number,
    required this.email,
    required this.ticketInfo,
    this.paymentScreenshot,
    required this.status,
    required this.note,
    required this.id,
    required this.ticketId,
    required this.submittedAt,
    required this.updatedAt,
  });

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    log('Parsing RegistrationData from: $json');

    return RegistrationData(
      eventId: json['eventId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      eventName: json['eventName']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      number: json['number']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      ticketInfo: json['ticketInfo'] != null
          ? TicketInfo.fromJson(json['ticketInfo'])
          : TicketInfo(tierName: '', price: 0.0, features: []),
      paymentScreenshot: json['paymentScreenshot']?.toString(),
      status: json['status']?.toString() ?? 'pending',
      note: json['note']?.toString() ?? '',
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      ticketId: json['ticketId']?.toString() ?? '',
      submittedAt: json['submittedAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}

class TicketInfo {
  final String tierName;
  final double price;
  final List<Feature> features;

  TicketInfo({
    required this.tierName,
    required this.price,
    required this.features,
  });

  factory TicketInfo.fromJson(Map<String, dynamic> json) {
    return TicketInfo(
      tierName: json['tierName'],
      price: (json['price'] as num).toDouble(),
      features:
          List<Feature>.from(json['features'].map((e) => Feature.fromJson(e))),
    );
  }
}

class Feature {
  final String name;
  final bool status;

  Feature({
    required this.name,
    required this.status,
  });

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(
      name: json['name'],
      status: json['status'],
    );
  }
}
