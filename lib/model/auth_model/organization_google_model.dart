class OrganizationGoogleData {
  final int status;
  final bool success;
  final UserData data;
  final String? error;
  final String message;
  final String timestamp;
  final String accessToken;

  OrganizationGoogleData({
    required this.status,
    required this.success,
    required this.data,
    required this.error,
    required this.message,
    required this.timestamp,
    required this.accessToken,
  });

  factory OrganizationGoogleData.fromJson(Map<String, dynamic> json) {
    return OrganizationGoogleData(
      status: json['status'],
      success: json['success'],
      data: UserData.fromJson(json['data']),
      error: json['error'],
      message: json['message'],
      timestamp: json['timestamp'],
      accessToken: json['accessToken'],
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
      'accessToken': accessToken,
    };
  }
}

class UserData {
  final String userId;
  final String name;
  final bool isVerified;
  final String email;
  final String? phone;
  final String gId;
  final String role;
  final String createdAt;
  final String updatedAt;

  UserData({
    required this.userId,
    required this.name,
    required this.isVerified,
    required this.email,
    this.phone,
    required this.gId,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'],
      name: json['name'],
      isVerified: json['isVerified'],
      email: json['email'],
      phone: json['phone'],
      gId: json['gId'],
      role: json['role'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'isVerified': isVerified,
      'email': email,
      'phone': phone,
      'gId': gId,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
