import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:eventsolutions/api.dart';
import 'package:eventsolutions/model/stall_model.dart';
import 'package:eventsolutions/services/token_storage.dart';

class StallsServices {
  final Dio dio = Dio();
  Future<List<StallModel>> fetchStalls() async {
    try {
      final token = TokenStorage().getAccessToken();
      final response = await dio.get(
        ApiServices.availableStalls,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        log('Stalls fetched successfully: ${data.length} stalls');
        return data.map((json) => StallModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load stalls');
      }
    } catch (e) {
      log('Error fetching stalls: $e');
      throw Exception('Failed to load stalls: $e');
    }
  }
}
