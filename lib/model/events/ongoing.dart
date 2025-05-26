import 'package:eventsolutions/model/abstract/event_data.dart';

class OngoingEventModel {
  final bool success;
  final String? error;
  final List<OngoingData> data;

  OngoingEventModel({required this.success, this.error, required this.data});

  factory OngoingEventModel.fromJson(Map<String, dynamic> json) {
    return OngoingEventModel(
      success: json['success'],
      error: json['error'],
      data: List<OngoingData>.from(
          json['data'].map((e) => OngoingData.fromJson(e))),
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

class OngoingData implements EventData {
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
  final List<OngoingTicketTier> ticketTiers;
  @override
  final String eventId;
  @override
  final String location;

  OngoingData(
      {this.poster,
      required this.eventId,
      required this.title,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.ticketTiers,
      required this.location});

  factory OngoingData.fromJson(Map<String, dynamic> json) {
    return OngoingData(
        title: json['title'],
        eventId: json['eventId'],
        poster: json['poster'],
        description: json['description'],
        startDate: json['startDateTime'],
        endDate: json['endDateTime'],
        ticketTiers: List<OngoingTicketTier>.from(
          json['ticketTiers'].map((e) => OngoingTicketTier.fromJson(e)),
        ),
        location: json['location']);
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
      'location': location
    };
  }
}

class OngoingTicketTier implements EventTicketTier {
  @override
  final String name;
  @override
  final double price;
  @override
  List<String> listofFeatures;

  OngoingTicketTier({
    required this.name,
    required this.price,
    required this.listofFeatures,
  });

  factory OngoingTicketTier.fromJson(Map<String, dynamic> json) {
    return OngoingTicketTier(
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
