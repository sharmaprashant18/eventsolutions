class TicketFeaturesModel {
  final String name;
  final bool status;
  TicketFeaturesModel({required this.name, required this.status});
  factory TicketFeaturesModel.fromJson(Map<String, dynamic> json) {
    return TicketFeaturesModel(name: json['name'], status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'status': status};
  }
}
