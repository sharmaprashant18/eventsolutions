import 'package:eventsolutions/model/abstract/event_data.dart';

class UpcomingEventModel {
  final bool success;
  final String? error;
  final List<UpcomingData> data;

  UpcomingEventModel({required this.success, this.error, required this.data});

  factory UpcomingEventModel.fromJson(Map<String, dynamic> json) {
    return UpcomingEventModel(
      success: json['success'],
      error: json['error'],
      data: List<UpcomingData>.from(
          json['data'].map((e) => UpcomingData.fromJson(e))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'error': error,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class UpcomingData implements EventData {
  @override
  final String? poster;
  @override
  final String title;
  @override
  final String description;
  @override
  final String startDate;
  @override
  final String endDate;
  @override
  final List<UpcomingTicketTier> ticketTiers;
  @override
  final String eventId;
  @override
  final String location;
  @override
  final bool hasStalls;

  UpcomingData(
      {this.poster,
      required this.eventId,
      required this.title,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.ticketTiers,
      required this.location,
      required this.hasStalls});

  factory UpcomingData.fromJson(Map<String, dynamic> json) {
    return UpcomingData(
        title: json['title'],
        eventId: json['eventId'],
        poster: json['poster'],
        description: json['description'],
        startDate: json['startDateTime'],
        endDate: json['endDateTime'],
        ticketTiers: List<UpcomingTicketTier>.from(
          json['ticketTiers'].map((e) => UpcomingTicketTier.fromJson(e)),
        ),
        location: json['location'],
        hasStalls: json['hasStalls'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'poster': poster,
      'description': description,
      'startDateTime': startDate,
      'endDateTime': endDate,
      'ticketTiers': ticketTiers.map((e) => e.toJson()).toList(),
      'eventId': eventId,
      'location': location,
      'hasStalls': hasStalls,
    };
  }
}

class UpcomingTicketTier implements EventTicketTier {
  @override
  final String name;
  @override
  final double price;
  @override
  List<String> listofFeatures;

  UpcomingTicketTier({
    required this.name,
    required this.price,
    required this.listofFeatures,
  });

  factory UpcomingTicketTier.fromJson(Map<String, dynamic> json) {
    return UpcomingTicketTier(
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      listofFeatures: List<String>.from(json['listOfFeatures']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'listOfFeatures': listofFeatures,
    };
  }
}
