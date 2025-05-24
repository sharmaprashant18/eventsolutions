class ContactUsModel {
  final bool success;
  final String message;

  ContactUsModel({required this.message, required this.success});
  factory ContactUsModel.fromJson(Map<String, dynamic> json) {
    return ContactUsModel(message: json['message'], success: json['success']);
  }
  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }
}
