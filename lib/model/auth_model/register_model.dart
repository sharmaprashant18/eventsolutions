// class LoginRegisterModel {
//   final bool success;
//   final String message;

//   final Data data;
//   LoginRegisterModel({
//     required this.data,
//     required this.message,
//     required this.success,
//   });
//   factory LoginRegisterModel.fromJson(Map<String, dynamic> json) {
//     return LoginRegisterModel(
//         data: Data.fromJson(json['data']),
//         message: json['message'],
//         success: json['success']);
//   }

//   Map<String, dynamic> toJson() {
//     return {'success': success, 'message': message, 'data': data.toJson()};
//   }
// }

// class Data {
//   final String message;
//   Data({required this.message});
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(message: json['message']);
//   }
//   Map<String, dynamic> toJson() {
//     return {'message': message};
//   }
// }

// Updated RegisterModel to match your API response
class LoginRegisterModel {
  final int status;
  final bool success;
  final RegisterData data;
  final dynamic error;
  final String message;
  final String timestamp;

  LoginRegisterModel({
    required this.status,
    required this.success,
    required this.data,
    required this.error,
    required this.message,
    required this.timestamp,
  });

  factory LoginRegisterModel.fromJson(Map<String, dynamic> json) {
    return LoginRegisterModel(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: RegisterData.fromJson(json['data'] ?? {}),
      error: json['error'],
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'data': data.toJson(),
      'error': error,
      'message': message,
      'timestamp': timestamp,
    };
  }
}

class RegisterData {
  final String message;

  RegisterData({required this.message});

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return RegisterData(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
