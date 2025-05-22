class LoginRegisterModel {
  final bool success;
  final String message;
  final Data data;
  LoginRegisterModel(
      {required this.data, required this.message, required this.success});
  factory LoginRegisterModel.fromJson(Map<String, dynamic> json) {
    return LoginRegisterModel(
        data: Data.fromJson(json['data']),
        message: json['message'],
        success: json['success']);
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class Data {
  final String message;
  Data({required this.message});
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(message: json['message']);
  }
  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
