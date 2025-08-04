abstract class EventData {
  String? get poster;
  String get title;
  String get description;
  String get startDate;
  String? get googleMapUrl;
  String? get organizer;
  String? get organizerLogo;
  String get endDate;
  List<EventTicketTier> get ticketTiers;
  String get eventId;
  String get location;
  bool get hasStalls;
  List<String> get floorPlans;
  String? get registrationOpen;
  String? get registrationClose;
  String get entryType;
  String get eventType;
  String? get proposal;
  String get scheduleStart;
  String get scheduleEnd;
  String? get managedBy;
  String? get managedByLogo;
}

abstract class EventTicketTier {
  String get name;
  double get price;
  List<String> get listofFeatures;
}
