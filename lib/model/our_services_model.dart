class OurServiceModel {
  final String name;
  final String description;
  final String icon;
  final String serviceId;
  final String createdAt;
  final String updatedAt;
  OurServiceModel(
      {required this.name,
      required this.description,
      required this.icon,
      required this.serviceId,
      required this.createdAt,
      required this.updatedAt});
  factory OurServiceModel.fromJson(Map<String, dynamic> json) {
    return OurServiceModel(
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      serviceId: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'icon': icon,
      '_id': serviceId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
