class RedeemTicketFeaturesModel {
  final String name;
  final bool status;
  RedeemTicketFeaturesModel({required this.name, required this.status});
  factory RedeemTicketFeaturesModel.fromJson(Map<String, dynamic> json) {
    return RedeemTicketFeaturesModel(
        name: json['name'], status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'status': status};
  }
}
