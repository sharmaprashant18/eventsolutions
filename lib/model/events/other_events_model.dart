class OtherEventsModel {
  final String id;
  final String title;
  final String location;
  final String startDateTime;
  final String endDateTime;
  final String poster;
  final String eventId;
  OtherEventsModel(
      {required this.id,
      required this.title,
      required this.location,
      required this.startDateTime,
      required this.endDateTime,
      required this.poster,
      required this.eventId});

  factory OtherEventsModel.fromJson(Map<String, dynamic> json) {
    return OtherEventsModel(
        id: json['_id'],
        title: json['title'],
        location: json['location'],
        startDateTime: json['startDateTime'],
        endDateTime: json['endDateTime'],
        poster: json['poster'],
        eventId: json['eventId']);
  }
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'location': location,
      'startDateTime': startDateTime,
      'endDateTime': endDateTime,
      'poster': poster,
      'eventId': eventId
    };
  }
}
