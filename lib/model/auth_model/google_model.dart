class GoogleData {
  final String name;
  final String email;

  final String userId;

  final String accessToken;

  GoogleData({
    required this.name,
    required this.email,
    required this.userId,
    required this.accessToken,
  });

  factory GoogleData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return GoogleData(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      userId: data['userId'] ?? '',
      accessToken: json['accessToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'userId': userId,
      'accessToken': accessToken,
    };
  }
}
