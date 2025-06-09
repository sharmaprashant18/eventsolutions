class UserDetailsModel {
  final String email;
  final String fullName;
  final String phone;
  final String role;

  UserDetailsModel({
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      email: json['email'] ?? '',
      fullName: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': fullName,
      'phone': phone,
      'role': role,
    };
  }
}
