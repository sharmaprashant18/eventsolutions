import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioClient {
  static Dio? _dio;
  static String? _accessToken;
  static String? _refreshToken;

  Dio get dio {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: 'http://182.93.94.210:8001/api/v1',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ));

      _dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null) {
            log(_accessToken!);
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          debugPrint('Request Headers: ${options.headers}');
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          return handler.next(e);
        },
      ));
    }
    return _dio!;
  }

  Future<String> _refreshAccessToken() async {
    try {
      final response = await Dio().post(
        'http://182.93.94.210:8001/api/v1/refresh-token',
        data: {'refreshToken': _refreshToken},
      );
      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];
      _accessToken = newAccessToken;
      _refreshToken = newRefreshToken;
      return newAccessToken;
    } catch (e) {
      debugPrint('Refresh token request failed: $e');
      rethrow;
    }
  }

  // Method to set tokens after login
  void setTokens(String accessToken, String refreshToken) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  // Method to clear tokens on logout
  void clearTokens() {
    _accessToken = null;
    _refreshToken = null;
  }
}
