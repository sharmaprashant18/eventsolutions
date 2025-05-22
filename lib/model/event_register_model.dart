class EventRegisterModel {
  final bool success;
  final String message;
  final RegistrationData data;

  EventRegisterModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory EventRegisterModel.fromJson(Map<String, dynamic> json) {
    return EventRegisterModel(
      success: json['success'],
      message: json['message'],
      data: RegistrationData.fromJson(json['data']),
    );
  }
}

class RegistrationData {
  final String id;
  final String email;
  final String name;
  final String number;
  final String tierName;
  final String paymentScreenshot;

  RegistrationData({
    required this.id,
    required this.email,
    required this.name,
    required this.number,
    required this.tierName,
    required this.paymentScreenshot,
  });

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    return RegistrationData(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      number: json['number'],
      tierName: json['tierName'],
      paymentScreenshot: json['paymentScreenshot'],
    );
  }
}
