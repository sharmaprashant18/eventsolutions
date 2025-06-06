class ForgotPasswordModel {
  final bool success;
  final String message;

  ForgotPasswordModel({
    required this.success,
    required this.message,
  });

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordModel(
      success: json['success'] as bool,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}


// {
//     "status": 200,
//     "success": true,
//     "data": null,
//     "error": null,
//     "message": "Email sent!",
//     "timestamp": "2025-06-06T07:15:16.279Z"
// }