class LoginModel {
  final bool success;
  final String message;
  final String accessToken;
  final UserData data;
  LoginModel(
      {required this.accessToken,
      required this.data,
      required this.message,
      required this.success});
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        accessToken: json['accessToken'],
        data: UserData.fromJson(json['data']),
        message: json['message'],
        success: json['success']);
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'data': data.toJson(),
      'message': message,
      'success': success
    };
  }
}

class UserData {
  final String email;
  final String role;
  final String userId;
  UserData({required this.email, required this.role, required this.userId});
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        email: json['email'], role: json['role'], userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'role': role, 'userId': userId};
  }
}
