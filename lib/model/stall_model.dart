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
