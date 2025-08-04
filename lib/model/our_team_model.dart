class OurTeamModel {
  final SocialLinks socialLinks;
  final String name;
  final String position;
  final String description;
  final String? photo;
  final String department;
  final int? hierarchyLevel;
  final String email;

  OurTeamModel(
      {required this.socialLinks,
      required this.name,
      required this.position,
      required this.description,
      required this.photo,
      required this.department,
      required this.hierarchyLevel,
      required this.email});

  factory OurTeamModel.fromJson(Map<String, dynamic> json) {
    return OurTeamModel(
        socialLinks: SocialLinks.fromJson(
          json['socialLinks'] ?? '',
        ),
        name: json['name'] ?? '',
        position: json['position'],
        description: json['description'] ?? '',
        photo: json['photo'] ?? '',
        department: json['department'] ?? '',
        hierarchyLevel: json['hierarchyLevel'] ?? '',
        email: json['email'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'socialLinks': socialLinks.toJson(),
      'name': name,
      'position': position,
      'description': description,
      'photo': photo,
      'department': department,
      'hierarchyLevel': hierarchyLevel ?? '',
      'email': email
    };
  }
}

class SocialLinks {
  final String? linkedin;
  final String? twitter;
  final String? facebook;
  final String? personal;
  SocialLinks({this.linkedin, this.twitter, this.facebook, this.personal});
  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
        linkedin: json['linkedin'] ?? '',
        twitter: json['twitter'] ?? '',
        facebook: json['facebook'] ?? '',
        personal: json['personal'] ?? '');
  }
  Map<String, dynamic> toJson() {
    return {
      'linkedin': linkedin ?? '',
      'twitter': twitter ?? '',
      'facebook': facebook ?? '',
      'personal': personal ?? ''
    };
  }
}
