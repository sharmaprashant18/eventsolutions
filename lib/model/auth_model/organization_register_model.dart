class OrganizationRegisterModel {
  final int status;
  final bool success;
  final String? data;
  final dynamic error;
  final String message;
  final String timestamp;

  OrganizationRegisterModel({
    required this.status,
    required this.success,
    this.data,
    required this.error,
    required this.message,
    required this.timestamp,
  });

  factory OrganizationRegisterModel.fromJson(Map<String, dynamic> json) {
    return OrganizationRegisterModel(
      status: json['status'] ?? 0,
      success: json['success'] ?? false,
      data: json['data'] ?? '',
      error: json['error'],
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'success': success,
      'data': data,
      'error': error,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
