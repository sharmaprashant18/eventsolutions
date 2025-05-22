// import 'package:dio/dio.dart';
// import 'token_storage.dart';

// class DioClient {
//   final Dio _dio = Dio(BaseOptions(
//     baseUrl: 'http://182.93.94.210:8000/api/v1',
//     connectTimeout: const Duration(seconds: 100),
//     receiveTimeout: const Duration(seconds: 100),
//     headers: {'Content-Type': 'application/json'},
//   ));

//   DioClient() {
//     _dio.interceptors.add(InterceptorsWrapper(
//       onRequest: (options, handler) async {
//         final token = await TokenStorage().getAccessToken();
//         if (token != null) {
//           options.headers['Authorization'] = 'Bearer $token';
//         }
//         return handler.next(options);
//       },
//       onError: (DioException e, handler) async {
//         if (e.response?.statusCode == 401) {
//           await TokenStorage().clearAccessToken();
//         }
//         return handler.next(e);
//       },
//     ));
//   }

//   Dio get dio => _dio;
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'token_storage.dart';

class DioClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://182.93.94.210:8000/api/v1',
    connectTimeout: const Duration(seconds: 100),
    receiveTimeout: const Duration(seconds: 100),
    headers: {'Content-Type': 'application/json'},
  ));

  DioClient() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorage().getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          debugPrint('Request Headers: ${options.headers}');
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          final refreshToken = await TokenStorage().getRefreshToken();
          if (refreshToken != null) {
            try {
              // Simulate token refresh (replace with actual API call)
              final newToken = await _refreshToken(refreshToken);
              if (newToken != null) {
                await TokenStorage().saveAccessToken(newToken);
                e.requestOptions.headers['Authorization'] = 'Bearer $newToken';
                debugPrint('Retrying request with new token');
                return handler.resolve(await _dio.fetch(e.requestOptions));
              }
            } catch (refreshError) {
              debugPrint('Token refresh failed: $refreshError');
              await TokenStorage().clearAllTokens();
            }
          }
          await TokenStorage().clearAccessToken();
        }
        return handler.next(e);
      },
    ));
  }

  Future<String?> _refreshToken(String refreshToken) async {
    // Replace with your actual refresh token API endpoint
    try {
      final response = await _dio
          .post('/refresh-token', data: {'refresh_token': refreshToken});
      return response.data['access_token'] as String?;
    } catch (e) {
      debugPrint('Refresh token request failed: $e');
      return null;
    }
  }

  Dio get dio => _dio;
}
