class UserDetailsModel {
  final String email;
  final String fullName;
  final String phone;

  UserDetailsModel({
    required this.email,
    required this.fullName,
    required this.phone,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      email: json['email'] ?? '',
      fullName: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': fullName,
      'phone': phone,
    };
  }
}
