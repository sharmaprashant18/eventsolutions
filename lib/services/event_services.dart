import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eventsolutions/api.dart';
import 'package:eventsolutions/model/events/all_events_model.dart';
import 'package:eventsolutions/model/contact_us_model.dart';
import 'package:eventsolutions/model/event_register_model.dart';
import 'package:eventsolutions/model/events/ongoing.dart';
import 'package:eventsolutions/model/events/upcoming.dart';
import 'package:eventsolutions/model/ticket_model.dart';
import 'package:eventsolutions/services/dio_client.dart';
import 'package:eventsolutions/services/token_storage.dart';
import 'package:flutter/material.dart';

class EventServices {
  final Dio dio = DioClient().dio;
  final ApiServices api = ApiServices();

  Future<List<Data>> fetchEvents() async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await Dio().get(
          // 'http://182.93.94.210:8000/api/v1/events',
          ApiServices.allEvents,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
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

  Future<List<OngoingData>> fetchOngoingEvents() async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await Dio().get(
          // 'http://182.93.94.210:8000/api/v1/events',
          ApiServices.ongoing,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final eventData = OngoingEventModel.fromJson(response.data);
        debugPrint(
            'Ongoing Events fetched successfully: ${eventData.data.length} events');
        return eventData.data;
      } else {
        throw Exception(
            'Failed to fetch Ongoingevents: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.message}');
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<UpcomingData>> fetchUpcomingEvents() async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await Dio().get(
          // 'http://182.93.94.210:8000/api/v1/events',
          ApiServices.upcoming,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final eventData = UpcomingEventModel.fromJson(response.data);
        debugPrint(
            'Upcoming Events fetched successfully: ${eventData.data.length} events');
        return eventData.data;
      } else {
        throw Exception(
            'Failed to fetch Upcomingevents: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.message}');
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<RegistrationData> registerEvent(
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
      final token = await TokenStorage().getAccessToken();
      final response = await Dio().post(
        'http://182.93.94.210:8000/api/v1/register-tickets',
        data: formData,
        options: Options(
            contentType: 'multipart/form-data',
            headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 201) {
        return RegistrationData.fromJson(response.data['data']);
      } else {
        throw Exception('Failed to register ticket: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data['message'] ?? 'Something went wrong',
        );
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  Future<TicketData> fetchTicketDetailsById(String ticketId) async {
    final token = await TokenStorage().getAccessToken();

    final response = await Dio().get(
      'http://182.93.94.210:8000/api/v1/tickets/$ticketId',
      options: Options(headers: {'Authorization': "Bearer $token"}),
    );

    if (response.statusCode == 200) {
      return TicketData.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to fetch ticket: ${response.statusMessage}');
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
