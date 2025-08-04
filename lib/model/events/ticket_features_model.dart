class TicketFeaturesModel {
  final bool? entry;
  final String name;
  final bool status;

  TicketFeaturesModel({required this.name, required this.status, this.entry});

  factory TicketFeaturesModel.fromJson(Map<String, dynamic> json) {
    return TicketFeaturesModel(
      name: json['name'] ?? '',
      status: json['status'] ?? false,
      entry: json['Entry'], // This can be null when not present
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'status': status,
    };
    if (entry != null) {
      data['entry'] = entry;
    }
    return data;
  }
}
