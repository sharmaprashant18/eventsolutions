import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:eventsolutions/api.dart';
import 'package:eventsolutions/model/stall/hold_stall_model.dart';
import 'package:eventsolutions/model/stall/one_stall_model.dart';
import 'package:eventsolutions/model/stall/pay_again_model.dart';
import 'package:eventsolutions/model/stall/stall_booking_model.dart';
import 'package:eventsolutions/model/stall/stall_model.dart';
import 'package:eventsolutions/model/stall/user_booking_details_model.dart';
import 'package:eventsolutions/services/token_storage.dart';
import 'package:flutter/foundation.dart';

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

  Future<MultipleStallHoldingModel> holdMultipleStall(
    List<String> stallIds,
    String contactPersonName,
    String contactPersonNumber,
    String contactPersonEmail,
  ) async {
    try {
      final holdingData = {
        'stallIds': stallIds,
        'contactPersonName': contactPersonName,
        'contactPersonNumber': contactPersonNumber,
        'contactPersonEmail': contactPersonEmail,
      };
      final token = await TokenStorage().getAccessToken();
      final response = await dio.post(
        ApiServices.multipleStallHold,
        data: holdingData,
        options: Options(
          contentType: 'application/json',
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 201) {
        final bookingData =
            MultipleStallHoldingModel.fromJson(response.data['data']);
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

  Future<MultipleStallBookingModel> bookStall(
      List<String> stallIds,
      String businessName,
      String businessPhone,
      String businessEmail,
      String contactPersonName,
      String contactPersonPhone,
      String contactPersonEmail,
      File paymentProof,
      String paidAmount,
      String paymentMethod) async {
    try {
      String fileName = paymentProof.path.split('/').last;
      FormData formData = FormData.fromMap({
        'stallIds': stallIds,
        'businessName': businessName,
        'businessPhone': businessPhone,
        'businessEmail': businessEmail,
        'contactPersonName': contactPersonName,
        'contactPersonPhone': contactPersonPhone,
        'contactPersonEmail': contactPersonEmail,
        'paymentProof':
            await MultipartFile.fromFile(paymentProof.path, filename: fileName),
        'paidAmount': paidAmount,
        'paymentMethod': 'bank'
      });
      final token = await TokenStorage().getAccessToken();
      final response = await dio.post(
        ApiServices.stallBooking, // Ensure API supports multiple stallIds
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 201) {
        final bookingData =
            MultipleStallBookingModel.fromJson(response.data['data']);
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

  Future<List<UserBookingDetailsModel>> fetchUserBooking() async {
    try {
      final token = await TokenStorage().getAccessToken();
      final response = await dio.get(ApiServices.userBookingsDetails,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        final List<UserBookingDetailsModel> userBooking =
            data.map((e) => UserBookingDetailsModel.fromJson(e)).toList();
        return userBooking;
      } else {
        throw Exception('Error getting the user booking details');
      }
    } on DioException catch (e) {
      debugPrint('Dio error: ${e.message}');
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Error getting the data:$e');
    }
  }

  Future<PayAgainModel> payagain(
    String bookingId,
    String paidAmount,
    String paymentMethod,
    File paymentProof,
  ) async {
    try {
      String fileName = paymentProof.path.split('/').last;
      FormData formData = FormData.fromMap({
        'bookingId': bookingId,
        'paidAmount': paidAmount,
        'paymentMethod': 'bank',
        'paymentProof':
            await MultipartFile.fromFile(paymentProof.path, filename: fileName),
      });
      final token = await TokenStorage().getAccessToken();
      final response = await dio.post(
        ApiServices.payAgain,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 200) {
        final payAgain = PayAgainModel.fromJson(response.data['data']);
        log('Paymeny successfully: ${payAgain.bookingId}');
        return payAgain;
      } else {
        throw Exception('Failed to Pay');
      }
    } catch (e) {
      log('Error paying: $e');
      throw Exception('Failed to pay: $e');
    }
  }
}
