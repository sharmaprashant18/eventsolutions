import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eventsolutions/api.dart';
import 'package:eventsolutions/model/stall/hold_stall_model.dart';
import 'package:eventsolutions/model/stall/one_stall_model.dart';
import 'package:eventsolutions/model/stall/stall_booking_model.dart';
import 'package:eventsolutions/model/stall/stall_model.dart';
import 'package:eventsolutions/services/token_storage.dart';

class StallsServices {
  final Dio dio = Dio();
  Future<StallData> fetchStalls(String eventId) async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await dio.get(
        ApiServices.availableStalls(eventId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        final stallData = StallData.fromJson(response.data['data']);
        log('Stalls fetched successfully: ${stallData.stall.length} stalls');
        return stallData;
      } else {
        throw Exception('Failed to load stalls');
      }
    } catch (e) {
      log('Error fetching stalls: $e');
      throw Exception('Failed to load stalls: $e');
    }
  }

  Future<StallModelById> fetchStallByID(String stallId) async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await dio.get(
        ApiServices.stallById(stallId),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        final stallData = StallModelById.fromJson(response.data['data']);
        log('Stalls fetched successfully: $stallId');
        return stallData;
      } else {
        throw Exception('Failed to load stalls');
      }
    } catch (e) {
      log('Error fetching stalls: $e');
      throw Exception('Failed to load stalls: $e');
    }
  }

  Future<StallBookingModel> bookStall(
    String stallId,
    String businessName,
    String businessPhone,
    String businessEmail,
    String contactPersonName,
    String contactPersonPhone,
    String contactPersonEmail,
    File paymentProof,
  ) async {
    try {
      String fileName = paymentProof.path.split('/').last;
      FormData formData = FormData.fromMap({
        'stallId': stallId,
        'businessName': businessName,
        'businessPhone': businessPhone,
        'businessEmail': businessEmail,
        'contactPersonName': contactPersonName,
        'contactPersonPhone': contactPersonPhone,
        'contactPersonEmail': contactPersonEmail,
        'paymentProof':
            await MultipartFile.fromFile(paymentProof.path, filename: fileName),
      });
      final token = await TokenStorage().getAccessToken();
      final response = await dio.post(ApiServices.stallBooking,
          data: formData,
          options: Options(
              contentType: 'multipart/form-data',
              headers: {"Authorization": "Bearer $token"}));
      if (response.statusCode == 201) {
        final bookingData = StallBookingModel.fromJson(response.data['data']);
        log('Stall booked successfully: ${bookingData.bookingId}');
        return bookingData;
      } else {
        throw Exception('Failed to book stall');
      }
    } catch (e) {
      log('Error booking stall: $e');
      throw Exception('Failed to book stall: $e');
    }
  }

  Future<HoldstallModel> holdStall(
    String stallId,
    String businessName,
    String businessPhone,
    String businessEmail,
    String contactPersonName,
    String contactPersonEmail,
    String contactPersonPhone,
  ) async {
    try {
      final payload = {
        'stallId': stallId,
        'businessName': businessName,
        'businessPhone': businessPhone,
        'businessEmail': businessEmail,
        'contactPersonName': contactPersonName,
        'contactPersonEmail': contactPersonEmail,
        'contactPersonPhone': contactPersonPhone,
      };
      final token = await TokenStorage().getAccessToken();
      final response = await dio.post(
        ApiServices.holdStall,
        data: payload,
        options: Options(
            contentType: 'application/json',
            headers: {"Authorization": "Bearer $token"}),
      );
      if (response.statusCode == 201) {
        final bookingData = HoldstallModel.fromJson(response.data['data']);
        log('Stall hold successfully: ${bookingData.bookingId}');
        return bookingData;
      } else {
        throw Exception('Failed to hold stall');
      }
    } catch (e) {
      log('Error holding stall: $e');
      throw Exception('Failed to hold stall: $e');
    }
  }
}
