class StallData {
  final String eventId;
  final String title;
  final String floorPlan;
  final List<StallModel> stall;
  StallData({
    required this.eventId,
    required this.title,
    required this.floorPlan,
    required this.stall,
  });

  factory StallData.fromJson(Map<String, dynamic> json) {
    return StallData(
      eventId: json['eventId'] ?? '',
      title: json['title'] ?? '',
      floorPlan: json['floorPlan'] ?? '',
      stall: (json['stalls'] as List)
          .map((item) => StallModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'title': title,
      'floorPlan': floorPlan,
      'stalls': stall.map((item) => item.toJson()).toList(),
    };
  }
}

class StallModel {
  final String name;
  final String status;
  final String stallId;
  StallModel({
    required this.name,
    required this.status,
    required this.stallId,
  });
  factory StallModel.fromJson(Map<String, dynamic> json) {
    return StallModel(
      name: json['name'] as String,
      status: json['status'] as String,
      stallId: json['stallId'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'stallId': stallId,
    };
  }
}
