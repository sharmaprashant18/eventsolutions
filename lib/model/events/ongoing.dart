import 'package:eventsolutions/abstract/event_data.dart';

class OngoingEventModel {
  final bool success;
  final String? error;
  final List<OngoingData> data;

  OngoingEventModel({required this.success, this.error, required this.data});

  factory OngoingEventModel.fromJson(Map<String, dynamic> json) {
    return OngoingEventModel(
      success: json['success'] as bool,
      error: json['error'] as String?,
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
  final List<TicketTier> ticketTiers;
  @override
  final String eventId;

  OngoingData({
    this.poster,
    required this.eventId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required List<OngoingTicketTier> this.ticketTiers,
  });

  factory OngoingData.fromJson(Map<String, dynamic> json) {
    return OngoingData(
      title: json['title'] as String,
      eventId: json['eventId'] as String,
      poster: json['poster'] as String?,
      description: json['description'] as String,
      startDate: json['startDateTime'] as String,
      endDate: json['endDateTime'] as String,
      ticketTiers: List<OngoingTicketTier>.from(
        json['ticketTiers'].map((e) => OngoingTicketTier.fromJson(e)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'poster': poster,
      'description': description,
      'startDateTime': startDate,
      'endDateTime': endDate,
      'ticketTiers':
          ticketTiers.map((e) => (e as OngoingTicketTier).toJson()).toList(),
      'eventId': eventId,
    };
  }
}

class OngoingTicketTier implements TicketTier {
  @override
  final String name;
  @override
  final double price;
  @override
  final List<String> listofFeatures;

  OngoingTicketTier({
    required this.name,
    required this.price,
    required this.listofFeatures,
  });

  factory OngoingTicketTier.fromJson(Map<String, dynamic> json) {
    return OngoingTicketTier(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      listofFeatures:
          List<String>.from(json['listOfFeatures'] as List<dynamic>),
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
