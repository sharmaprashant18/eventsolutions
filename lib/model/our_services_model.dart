class OurServiceModel {
  final String name;
  final String description;
  final String image;
  final String serviceId;
  final String createdAt;
  final String updatedAt;
  OurServiceModel(
      {required this.name,
      required this.description,
      required this.image,
      required this.serviceId,
      required this.createdAt,
      required this.updatedAt});
  factory OurServiceModel.fromJson(Map<String, dynamic> json) {
    return OurServiceModel(
      name: json['name'],
      description: json['description'],
      image: json['image'],
      serviceId: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': image,
      '_id': serviceId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
