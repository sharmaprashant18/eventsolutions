abstract class EventData {
  String? get poster;
  String get title;
  String get description;
  String get startDate;
  String get endDate;
  List<EventTicketTier> get ticketTiers;
  String get eventId;
  String get location;
  bool get hasStalls;
}

abstract class EventTicketTier {
  String get name;
  double get price;
  List<String> get listofFeatures;
}
