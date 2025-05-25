abstract class EventData {
  String get title;
  String? get poster;
  String get description;
  List<TicketTier> get ticketTiers;
  String get eventId;
  String get startDate;
  String get endDate;
}

abstract class TicketTier {
  String get name;
  double get price;
  List<String> get listofFeatures;
}
