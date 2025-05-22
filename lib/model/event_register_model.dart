class EventRegisterModel {
  final String status;
  final String data;
  final String message;
  EventRegisterModel(
      {required this.data, required this.message, required this.status});

  factory EventRegisterModel.fromJson(Map<String, dynamic> json) {
    return EventRegisterModel(
        data: json['data'], message: json['message'], status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {'data': data, 'message': message, 'status': status};
  }
}
