class EventsModel {
  final bool success;
  final String? error;
  final List<Data> data;

  EventsModel({required this.success, this.error, required this.data});

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      success: json['success'],
      error: json['error'],
      data: List<Data>.from(json['data'].map((e) => Data.fromJson(e))),
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

class Data {
  final String? poster;
  final String title;
  final String description;
  final String startDate;
  final String endDate;
  final List<TicketTiers> ticketTiers;
  final String eventId;

  Data({
    this.poster,
    required this.eventId,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.ticketTiers,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      title: json['title'],
      eventId: json['eventId'],
      poster: json['poster'],
      description: json['description'],
      startDate: json['startDateTime'],
      endDate: json['endDateTime'],
      ticketTiers: List<TicketTiers>.from(
        json['ticketTiers'].map((e) => TicketTiers.fromJson(e)),
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
      'ticketTiers': ticketTiers.map((e) => e.toJson()).toList(),
      'eventId': eventId,
    };
  }
}

class TicketTiers {
  final String name;
  final double price;
  List<String> listofFeatures;

  TicketTiers({
    required this.name,
    required this.price,
    required this.listofFeatures,
  });

  factory TicketTiers.fromJson(Map<String, dynamic> json) {
    return TicketTiers(
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
