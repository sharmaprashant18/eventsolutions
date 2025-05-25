import 'package:eventsolutions/abstract/event_data.dart';

class UpcomingEventModel {
  final bool success;
  final String? error;
  final List<UpcomingData> data;

  UpcomingEventModel({required this.success, this.error, required this.data});

  factory UpcomingEventModel.fromJson(Map<String, dynamic> json) {
    return UpcomingEventModel(
      success: json['success'] as bool,
      error: json['error'] as String?,
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
  final List<TicketTier> ticketTiers;
  @override
  final String eventId;

  UpcomingData({
    this.poster,
    required this.eventId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required List<UpcomingTicketTier> this.ticketTiers,
  });

  factory UpcomingData.fromJson(Map<String, dynamic> json) {
    return UpcomingData(
      title: json['title'] as String,
      eventId: json['eventId'] as String,
      poster: json['poster'] as String?,
      description: json['description'] as String,
      startDate: json['startDateTime'] as String,
      endDate: json['endDateTime'] as String,
      ticketTiers: List<UpcomingTicketTier>.from(
        json['ticketTiers'].map((e) => UpcomingTicketTier.fromJson(e)),
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
          ticketTiers.map((e) => (e as UpcomingTicketTier).toJson()).toList(),
      'eventId': eventId,
    };
  }
}

class UpcomingTicketTier implements TicketTier {
  @override
  final String name;
  @override
  final double price;
  @override
  final List<String> listofFeatures;

  UpcomingTicketTier({
    required this.name,
    required this.price,
    required this.listofFeatures,
  });

  factory UpcomingTicketTier.fromJson(Map<String, dynamic> json) {
    return UpcomingTicketTier(
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
