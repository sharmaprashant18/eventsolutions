import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eventsolutions/model/all_events_model.dart';
import 'package:eventsolutions/model/contact_us_model.dart';
import 'package:eventsolutions/model/event_register_model.dart';
import 'package:eventsolutions/model/ticket_model.dart';
import 'package:eventsolutions/services/dio_client.dart';
import 'package:flutter/material.dart';

class EventServices {
  final Dio dio = DioClient().dio;

  Future<List<Data>> fetchEvents() async {
    try {
      final response = await dio.get('/events');
      if (response.statusCode == 200) {
        final eventData = EventsModel.fromJson(response.data);
        debugPrint(
            'Events fetched successfully: ${eventData.data.length} events');
        return eventData.data;
      } else {
        throw Exception('Failed to fetch events: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.message}');
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<EventRegisterModel> registerEvent(
    String email,
    String name,
    String number,
    String tierName,
    File paymentScreenshot,
    String eventId,
  ) async {
    try {
      String fileName = paymentScreenshot.path.split('/').last;

      FormData formData = FormData.fromMap({
        'eventId': eventId,
        'email': email,
        'name': name,
        'number': number,
        'tierName': tierName,
        'paymentScreenshot': await MultipartFile.fromFile(
          paymentScreenshot.path,
          filename: fileName,
        ),
      });

      final response = await dio.post(
        '/register-tickets',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      return EventRegisterModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Something went wrong',
        );
      } else {
        throw Exception('Network error');
      }
    }
  }

  Future<TicketModel> fetchTicketDetails(String ticketId) async {
    try {
      final response = await dio.get('/tickets/$ticketId');
      if (response.statusCode == 200) {
        debugPrint(
            'Ticket details fetched successfully for ticketId: $ticketId');
        return TicketModel.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to fetch ticket details: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.message}');
      throw Exception(
        e.response?.data['message'] ??
            'Error fetching ticket details: ${e.message}',
      );
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<ContactUsModel> register(
      String email, String name, String message) async {
    try {
      final response = await dio.post('/contact',
          data: {'email': email, 'name': name, 'message': message});
      return ContactUsModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Submitting email failed');
      } else {
        throw Exception('Network error');
      }
    }
  }
}

// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:eventsolutions/model/all_events_model.dart';
// import 'package:eventsolutions/model/contact_us_model.dart';
// import 'package:eventsolutions/model/event_register_model.dart';
// import 'package:eventsolutions/model/ticket_model.dart';
// import 'package:eventsolutions/services/dio_client.dart';
// import 'package:flutter/material.dart';

// class EventServices {
//   final Dio dio = DioClient().dio;

//   Future<List<Data>> fetchEvents() async {
//     try {
//       final response = await dio.get('/events');
//       if (response.statusCode == 200) {
//         final eventData = EventsModel.fromJson(response.data);
//         debugPrint(
//             'Events fetched successfully: ${eventData.data.length} events');
//         return eventData.data;
//       } else {
//         throw Exception('Failed to fetch events: ${response.statusMessage}');
//       }
//     } on DioException catch (e) {
//       debugPrint('Dio error: ${e.message}');
//       throw Exception('Dio error: ${e.message}');
//     } catch (e) {
//       debugPrint('Unexpected error: $e');
//       throw Exception('Unexpected error: $e');
//     }
//   }

//   Future<EventRegisterModel> registerEvent(
//     String email,
//     String name,
//     String number,
//     String tierName,
//     File paymentScreenshot,
//     String eventId,
//   ) async {
//     try {
//       // ... your existing registration logic
//       final response = await dio.post('/register-tickets', data: {
//         'email': email,
//         'name': name,
//         'number': number,
//         'tierName': tierName,
//         'paymentScreenshot':
//             paymentScreenshot, // Adjust based on how you handle file uploads
//         'eventId': eventId,
//       });
//       debugPrint('Registration Response: ${response.data}');
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         final eventRegisterModel = EventRegisterModel.fromJson(response.data);
//         debugPrint('Registered Ticket ID: ${eventRegisterModel.data.ticketId}');
//         return eventRegisterModel;
//       } else {
//         throw Exception('Failed to register: ${response.statusMessage}');
//       }
//     } catch (e) {
//       debugPrint('Error registering event: $e');
//       throw Exception('Registration failed: $e');
//     }
//   }

//   // Future<EventRegisterModel> registerEvent(
//   //   String email,
//   //   String name,
//   //   String number,
//   //   String tierName,
//   //   File paymentScreenshot,
//   //   String eventId,
//   // ) async {
//   //   try {
//   //     String fileName = paymentScreenshot.path.split('/').last;

//   //     FormData formData = FormData.fromMap({
//   //       'eventId': eventId,
//   //       'email': email,
//   //       'name': name,
//   //       'number': number,
//   //       'tierName': tierName,
//   //       'paymentScreenshot': await MultipartFile.fromFile(
//   //         paymentScreenshot.path,
//   //         filename: fileName,
//   //       ),
//   //     });

//   //     final response = await dio.post(
//   //       '/register-tickets',
//   //       data: formData,
//   //       options: Options(
//   //         contentType: 'multipart/form-data',
//   //       ),
//   //     );

//   //     return EventRegisterModel.fromJson(response.data);
//   //   } on DioException catch (e) {
//   //     if (e.response != null) {
//   //       throw Exception(
//   //         e.response?.data['message'] ?? 'Something went wrong',
//   //       );
//   //     } else {
//   //       throw Exception('Network error');
//   //     }
//   //   }
//   // }

//   // Future<TicketModel> fetchTicketDetails(String ticketId) async {
//   //   try {
//   //     final response = await dio.get('/tickets/$ticketId');
//   //     if (response.statusCode == 200) {
//   //       debugPrint(
//   //           'Ticket details fetched successfully for ticketId: $ticketId');
//   //       return TicketModel.fromJson(response.data);
//   //     } else {
//   //       throw Exception(
//   //           'Failed to fetch ticket details: ${response.statusMessage}');
//   //     }
//   //   } on DioException catch (e) {
//   //     debugPrint('Dio error: ${e.message}');
//   //     throw Exception(
//   //       e.response?.data['message'] ??
//   //           'Error fetching ticket details: ${e.message}',
//   //     );
//   //   } catch (e) {
//   //     debugPrint('Unexpected error: $e');
//   //     throw Exception('Unexpected error: $e');
//   //   }
//   // }

//   Future<TicketModel> fetchTicketDetails(String ticketId) async {
//     try {
//       final response = await dio.get('/tickets/$ticketId');
//       debugPrint('Response Status: ${response.statusCode}');
//       debugPrint('Response Data: ${response.data}');
//       if (response.statusCode == 200) {
//         debugPrint(
//             'Ticket details fetched successfully for ticketId: $ticketId');
//         return TicketModel.fromJson(response.data);
//       } else {
//         throw Exception(
//             'Failed to fetch ticket details: ${response.statusCode} - ${response.statusMessage}');
//       }
//     } on DioException catch (e) {
//       debugPrint('Dio error: ${e.message}');
//       debugPrint('Response Status: ${e.response?.statusCode}');
//       debugPrint('Response Data: ${e.response?.data}');
//       throw Exception(
//         e.response?.data['message'] ??
//             'Error fetching ticket details: ${e.message}',
//       );
//     } catch (e) {
//       debugPrint('Unexpected error: $e');
//       throw Exception('Unexpected error: $e');
//     }
//   }

//   Future<ContactUsModel> register(
//       String email, String name, String message) async {
//     try {
//       final response = await dio.post('/contact',
//           data: {'email': email, 'name': name, 'message': message});
//       return ContactUsModel.fromJson(response.data);
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(
//             e.response?.data['message'] ?? 'Submitting email failed');
//       } else {
//         throw Exception('Network error');
//       }
//     }
//   }
// }
