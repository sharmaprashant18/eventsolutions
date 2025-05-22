// import 'package:dio/dio.dart';
// import 'package:eventsolutions/model/all_events_model.dart';
// import 'package:eventsolutions/services/dio_client.dart';

// class EventServices {
//   final Dio dio = DioClient().dio;

//   Future<List<Data>> fetchEvents() async {
//     try {
//       final response = await dio.get(
//         '/events',
//       );
//       if (response.statusCode == 200) {
//         final eventData = EventsModel.fromJson(response.data);
//         return eventData.data;
//       } else {
//         throw Exception('Failed to fetch events: ${response.statusMessage}');
//       }
//     } on DioException catch (e) {
//       throw Exception('Dio error: ${e.message}');
//     } catch (e) {
//       throw Exception('Unexpected error: $e');
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:eventsolutions/model/all_events_model.dart';
import 'package:eventsolutions/model/event_register_model.dart';
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
      String email, String name, String number, String tierName) async {
    try {
      final response = await dio.post('/register-tickets', data: {
        'email': email,
        'name': name,
        'number': number,
        'tierName': tierName
      });
      return EventRegisterModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Payment Screenshot is required');
      } else {
        throw Exception('Network error');
      }
    }
  }
}
