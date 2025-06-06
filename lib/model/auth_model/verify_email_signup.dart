class VerifyEmailSignupModel {
  final bool success;
  final String message;
  final String? data;
  final ErrorMessage messages;

  VerifyEmailSignupModel(
      {required this.success,
      required this.message,
      this.data,
      required this.messages});
  factory VerifyEmailSignupModel.fromJson(Map<String, dynamic> json) {
    return VerifyEmailSignupModel(
      success: json['success'],
      message: json['message'],
      messages: ErrorMessage.fromJson(json['messages'] ?? {'message': ''}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'messages': messages.toJson(),
      'data': data
    };
  }
}

class ErrorMessage {
  final String message;

  ErrorMessage({required this.message});
  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(message: json['message']);
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
