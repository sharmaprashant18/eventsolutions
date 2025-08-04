// class StallData {
//   final String eventId;
//   final String title;
//   final String? floorPlan;
//   final List<StallModel> stall;
//   final List<String> floorPlans;
//   StallData({
//     required this.eventId,
//     required this.title,
//     this.floorPlan,
//     required this.stall,
//     required this.floorPlans,
//   });

//   factory StallData.fromJson(Map<String, dynamic> json) {
//     return StallData(
//       eventId: json['eventId'] ?? '',
//       title: json['title'] ?? '',
//       floorPlan: json['floorPlan'] ?? '',
//       // floorPlans: (json['floorPlans'] as List<dynamic> ?? [])
//       //     .map((item) => item.toString())
//       //     .toList(),
//       floorPlans: (json['floorPlans'] != null
//               ? (json['floorPlans'] as List<dynamic>)
//               : <dynamic>[])
//           .map((item) => item.toString())
//           .toList(),
//       stall: (json['stalls'] as List)
//           .map((item) => StallModel.fromJson(item))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'eventId': eventId,
//       'title': title,
//       'floorPlan': floorPlan,
//       'stalls': stall.map((item) => item.toJson()).toList(),
//       'floorPlans': floorPlans.map((item) => item.toString()).toList(),
//     };
//   }
// }

// class StallModel {
//   final String name;
//   final String status;
//   final String stallId;
//   StallModel({
//     required this.name,
//     required this.status,
//     required this.stallId,
//   });
//   factory StallModel.fromJson(Map<String, dynamic> json) {
//     return StallModel(
//       name: json['name'] as String,
//       status: json['status'] as String,
//       stallId: json['stallId'] as String,
//     );
//   }
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'status': status,
//       'stallId': stallId,
//     };
//   }
// }

class StallData {
  final String eventId;
  final String title;
  final String? floorPlan;
  final List<StallModel> stall;
  final List<String> floorPlans;

  StallData({
    required this.eventId,
    required this.title,
    this.floorPlan,
    required this.stall,
    required this.floorPlans,
  });

  factory StallData.fromJson(Map<String, dynamic> json) {
    return StallData(
      eventId: json['eventId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      floorPlan: json['floorPlan']?.toString(),

      // Safe handling of floorPlans list
      floorPlans: _parseStringList(json['floorPlans']),

      // Safe handling of stalls list
      stall: _parseStallList(json['stalls']),
    );
  }

  // Helper method to safely parse string lists
  static List<String> _parseStringList(dynamic value) {
    if (value == null) return <String>[];

    if (value is List) {
      return value
          .where((item) => item != null)
          .map((item) => item.toString())
          .toList();
    }

    return <String>[];
  }

  // Helper method to safely parse stall lists
  static List<StallModel> _parseStallList(dynamic value) {
    if (value == null) return <StallModel>[];

    if (value is List) {
      return value
          .where((item) => item != null && item is Map<String, dynamic>)
          .map((item) => StallModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return <StallModel>[];
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'title': title,
      'floorPlan': floorPlan,
      'stalls': stall.map((item) => item.toJson()).toList(),
      'floorPlans': floorPlans,
    };
  }

  // Optional: Override toString for debugging
  @override
  String toString() {
    return 'StallData(eventId: $eventId, title: $title, floorPlan: $floorPlan, '
        'stall: ${stall.length} items, floorPlans: ${floorPlans.length} items)';
  }

  // Optional: Copy method for immutable updates
  StallData copyWith({
    String? eventId,
    String? title,
    String? floorPlan,
    List<StallModel>? stall,
    List<String>? floorPlans,
  }) {
    return StallData(
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      floorPlan: floorPlan ?? this.floorPlan,
      stall: stall ?? this.stall,
      floorPlans: floorPlans ?? this.floorPlans,
    );
  }
}

class StallModel {
  final String name;
  final String status;
  final String stallId;

  StallModel({
    required this.name,
    required this.status,
    required this.stallId,
  });

  factory StallModel.fromJson(Map<String, dynamic> json) {
    return StallModel(
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      stallId: json['stallId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'stallId': stallId,
    };
  }

  // Optional: Override toString for debugging
  @override
  String toString() {
    return 'StallModel(name: $name, status: $status, stallId: $stallId)';
  }

  // Optional: Override equality operators
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StallModel &&
        other.name == name &&
        other.status == status &&
        other.stallId == stallId;
  }

  @override
  int get hashCode => name.hashCode ^ status.hashCode ^ stallId.hashCode;

  // Optional: Copy method for immutable updates
  StallModel copyWith({
    String? name,
    String? status,
    String? stallId,
  }) {
    return StallModel(
      name: name ?? this.name,
      status: status ?? this.status,
      stallId: stallId ?? this.stallId,
    );
  }
}
