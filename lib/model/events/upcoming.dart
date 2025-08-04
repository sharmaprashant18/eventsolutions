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
  @override
  final List<String> floorPlans;
  @override
  final String? registrationOpen;
  @override
  final String? registrationClose;
  @override
  final String entryType;
  @override
  final String eventType;
  @override
  final String? proposal;
  @override
  final String scheduleStart;
  @override
  final String scheduleEnd;
  @override
  final String? organizer;
  @override
  final String? organizerLogo;
  @override
  final String? googleMapUrl;

  @override
  final String? managedBy;
  @override
  final String? managedByLogo;
  UpcomingData(
      {this.poster,
      required this.eventId,
      required this.title,
      required this.description,
      required this.startDate,
      required this.endDate,
      required this.ticketTiers,
      required this.location,
      required this.hasStalls,
      required this.floorPlans,
      this.registrationOpen,
      this.registrationClose,
      required this.entryType,
      required this.eventType,
      this.proposal,
      required this.scheduleStart,
      required this.scheduleEnd,
      this.organizer,
      this.organizerLogo,
      this.googleMapUrl,
      this.managedBy,
      this.managedByLogo});

  factory UpcomingData.fromJson(Map<String, dynamic> json) {
    return UpcomingData(
        title: json['title'],
        eventId: json['eventId'],
        poster: json['poster'],
        description: json['description'],
        startDate: json['startDateTime'],
        endDate: json['endDateTime'],
        floorPlans: List<String>.from(json['floorPlans'] ?? []),
        ticketTiers: List<UpcomingTicketTier>.from(
          json['ticketTiers'].map((e) => UpcomingTicketTier.fromJson(e)),
        ),
        location: json['location'],
        hasStalls: json['hasStalls'] ?? false,
        registrationOpen: json['registrationOpen'] ?? '',
        registrationClose: json['registrationClose'] ?? '',
        entryType: json['entryType'],
        eventType: json['eventType'],
        proposal: json['proposal'],
        scheduleStart: json['scheduleStart'],
        scheduleEnd: json['scheduleEnd'],
        organizer: json['organizer'] ?? '',
        organizerLogo: json['organizerLogo'] ?? '',
        googleMapUrl: json['googleMapUrl'] ?? '',
        managedBy: json['managedBy'] ?? '',
        managedByLogo: json['managedByLogo'] ?? '');
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
      'floorPlans': floorPlans.map((e) => e).toList(),
      'registrationOpen': registrationOpen,
      'registrationClose': registrationClose,
      'entryType': entryType,
      ' eventType': eventType,
      'proposal': proposal,
      'scheduleStart': scheduleStart,
      'scheduleEnd': scheduleEnd,
      'organizer': organizer,
      'organizerLogo': organizerLogo,
      'googleMapUrl': googleMapUrl,
      'managedBy': managedBy,
      'managedByLogo': managedByLogo
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
