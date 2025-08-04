class QrCodeModel {
  final String name;
  final String image;
  QrCodeModel({required this.image, required this.name});
  factory QrCodeModel.fromJson(Map<String, dynamic> json) {
    return QrCodeModel(image: json['image'], name: json['name']);
  }
  Map<String, dynamic> toJson() {
    return {'image': image, 'name': name};
  }
}
