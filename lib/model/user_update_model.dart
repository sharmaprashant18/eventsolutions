class UserUpdateModel {
  final String name;
  final String number;
  final String email;

  UserUpdateModel({
    required this.name,
    required this.number,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': number,
      'email': email,
    };
  }

  factory UserUpdateModel.fromJson(Map<String, dynamic> json) {
    return UserUpdateModel(
      name: json['name'] ?? '',
      number: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class UpdateResponseModel {
  final int status;
  final bool success;
  final dynamic data;
  final String? error;
  final String message;
  final String timestamp;

  UpdateResponseModel({
    required this.status,
    required this.success,
    this.data,
    this.error,
    required this.message,
    required this.timestamp,
  });

  factory UpdateResponseModel.fromJson(Map<String, dynamic> json) {
    print('Parsing UpdateResponseModel from: $json'); // Debug log

    return UpdateResponseModel(
      status: _parseToInt(json['status']),
      success: _parseToBool(json['success']),
      data: json['data'],
      error: json['error']?.toString(),
      message: json['message']?.toString() ?? '',
      timestamp: json['timestamp']?.toString() ?? '',
    );
  }

  static int _parseToInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _parseToBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }
}
