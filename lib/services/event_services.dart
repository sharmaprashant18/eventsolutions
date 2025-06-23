import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eventsolutions/api.dart';
import 'package:eventsolutions/model/events/all_events_model.dart';
import 'package:eventsolutions/model/contact_us_model.dart';
import 'package:eventsolutions/model/event_register_model.dart';
import 'package:eventsolutions/model/events/ongoing.dart';
import 'package:eventsolutions/model/events/other_events_model.dart';
import 'package:eventsolutions/model/events/reedem_ticket_features_model.dart';
import 'package:eventsolutions/model/events/ticket_features_model.dart';
import 'package:eventsolutions/model/events/upcoming.dart';
import 'package:eventsolutions/model/our_services_model.dart';
import 'package:eventsolutions/model/our_team_model.dart';
import 'package:eventsolutions/model/ticket_model.dart';
import 'package:eventsolutions/services/auth_services/dio_client.dart';
import 'package:eventsolutions/services/token_storage.dart';
import 'package:flutter/material.dart';

class EventServices {
  final Dio dio = DioClient().dio;
  final ApiServices api = ApiServices();

  Future<List<Data>> fetchEvents() async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await Dio().get(ApiServices.allEvents,
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
      final response = await Dio().get(ApiServices.ongoing,
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
      final response = await Dio().get(ApiServices.upcoming,
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

  Future<List<OurServiceModel>> fetchOurService() async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await Dio().get(ApiServices.services,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final List<dynamic> dataList = response.data['data'];

        final List<OurServiceModel> services =
            dataList.map((json) => OurServiceModel.fromJson(json)).toList();

        debugPrint(
            'Our Services fetched successfully: ${services.length} events');
        return services;
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
        'http://182.93.94.210:8001/api/v1/register-tickets',
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
      'http://182.93.94.210:8001/api/v1/tickets/$ticketId',
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

  Future<List<TicketFeaturesModel>> getTicketFeaturesByTicketId(
      String ticketId) async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await dio.get(
        ApiServices.featuresByTicketId(ticketId),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<TicketFeaturesModel> featuresofTicket =
            data.map((e) => TicketFeaturesModel.fromJson(e)).toList();
        return featuresofTicket;
      } else {
        throw Exception('Error getting the features');
      }
    } on DioException catch (e) {
      log('$e');
      throw Exception('Error getting the features');
    } catch (e) {
      log('$e');
      throw Exception('Error getting the features');
    }
  }

  Future<List<RedeemTicketFeaturesModel>> redeemTicketFeaturesByTicketId(
      String ticketId, String featureName) async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await dio.patch(
        ApiServices.reedemFeaturesByTicketId(ticketId),
        data: {'featureName': featureName},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<RedeemTicketFeaturesModel> featuresofTicket =
            data.map((e) => RedeemTicketFeaturesModel.fromJson(e)).toList();
        return featuresofTicket;
      } else {
        throw Exception('Error redeeming the features');
      }
    } on DioException catch (e) {
      log('$e');
      throw Exception('Error redeeming mg the features');
    } catch (e) {
      log('$e');
      throw Exception('Error getting the features');
    }
  }

  Future<List<OtherEventsModel>> fetchOtherEvents() async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await dio.get(ApiServices.otherEvents,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final List<dynamic> otherEventsData = response.data['data'];
        final List<OtherEventsModel> data =
            otherEventsData.map((e) => OtherEventsModel.fromJson(e)).toList();
        return data;
      } else {
        throw Exception('Error getting the events');
      }
    } on DioException catch (e) {
      throw Exception('Error to fetch the all events:$e');
    } catch (e) {
      throw Exception('Error to fetch the all events:$e');
    }
  }

  Future<List<OurTeamModel>> fetchOurTeam() async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await dio.get(ApiServices.ourTeam,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final List<dynamic> teamData = response.data['data'];
        final List<OurTeamModel> teamMemberData =
            teamData.map((e) => OurTeamModel.fromJson(e)).toList();
        return teamMemberData;
      } else {
        throw Exception('Error to get the team members');
      }
    } catch (e) {
      throw Exception('Error to get the team members');
    }
  }
}
