// import 'dart:developer';

// import 'package:dio/dio.dart';
// import 'package:eventsolutions/api.dart';
// import 'package:eventsolutions/model/auth_model/forgot_password_model.dart';
// import 'package:eventsolutions/model/auth_model/verify_model.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:eventsolutions/model/auth_model/login_model.dart';
// import 'package:eventsolutions/model/auth_model/register_model.dart';

// import 'package:eventsolutions/services/token_storage.dart';

// class AuthService {
//   // final Dio _dio = DioClient().dio;
//   final TokenStorage _tokenStorage = TokenStorage();

//   Future<void> saveToken(String accessToken, String refreshToken) async {
//     // ignore: unused_local_variable
//     final prefs = await SharedPreferences.getInstance();
//     await _tokenStorage.saveAccessToken(accessToken);
//     await _tokenStorage.saveRefreshToken(refreshToken);
//     debugPrint('Access and refresh tokens saved');
//   }

//   Future<LoginModel> login(String email, String password) async {
//     try {
//       final token = await _tokenStorage.getAccessToken();
//       final response = await Dio().post(ApiServices.login,
//           data: {
//             'email': email,
//             'password': password,
//           },
//           options: Options(headers: {'Authorization': 'Bearer $token'}));
//       final loginModel = LoginModel.fromJson(response.data);
//       debugPrint("Access Token: ${loginModel.accessToken}");

//       await saveToken(loginModel.accessToken, loginModel.accessToken);
//       log(loginModel.accessToken);
//       return loginModel;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response?.data['message'] ?? 'Login failed');
//       } else {
//         throw Exception('Network error');
//       }
//     }
//   }

//   Future<LoginRegisterModel> register(
//     String email,
//     String password,
//     String fullName,
//     String phone,
//   ) async {
//     try {
//       final token = await _tokenStorage.getAccessToken();
//       final response = await Dio().post(ApiServices.register,
//           data: {
//             'email': email,
//             'password': password,
//             'fullName': fullName,
//             'phone': phone
//           },
//           options: Options(headers: {'Authorization': 'Bearer $token'}));
//       return LoginRegisterModel.fromJson(response.data);
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response?.data['message'] ?? 'Registration failed');
//       } else {
//         throw Exception('Network error');
//       }
//     }
//   }

//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('access_token');
//   }

//   Future<ForgotPasswordModel> forgotPassword(String email) async {
//     try {
//       final response = await Dio().post(ApiServices.forgotPassword, data: {
//         'email': email,
//       });

//       return ForgotPasswordModel.fromJson(response.data);
//     } on DioException catch (e) {
//       throw Exception(e.response?.data['message'] ?? 'Failed to send OTP');
//     }
//   }

//   Future<VerifyModel> verifyCode({
//     required String email,
//     required String code,
//     required String newPassword,
//   }) async {
//     try {
//       final response = await Dio().post(ApiServices.verify, data: {
//         'email': email,
//         'enteredCode': code,
//         'newPassword': newPassword,
//       });

//       return VerifyModel.fromJson(response.data);
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response?.data['message'] ?? 'Password reset failed');
//       } else {
//         throw Exception('Network error');
//       }
//     }
//   }
// }

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:eventsolutions/api.dart';
import 'package:eventsolutions/model/auth_model/forgot_password_model.dart';
import 'package:eventsolutions/model/auth_model/verify_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventsolutions/model/auth_model/login_model.dart';
import 'package:eventsolutions/model/auth_model/register_model.dart';

import 'package:eventsolutions/services/token_storage.dart';

class AuthService {
  final TokenStorage _tokenStorage = TokenStorage();

  Future<void> saveToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await _tokenStorage.saveAccessToken(accessToken);
    await _tokenStorage.saveRefreshToken(refreshToken);
    debugPrint('Access and refresh tokens saved');
  }

  Future<LoginModel> login(String email, String password) async {
    try {
      // DON'T send token for login - this is a public endpoint
      final response = await Dio().post(
        ApiServices.login,
        data: {
          'email': email,
          'password': password,
        },
        // Remove the Authorization header for login
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      final loginModel = LoginModel.fromJson(response.data);
      debugPrint("Access Token: ${loginModel.accessToken}");

      // Save both tokens (assuming you have refresh token, otherwise just save access token twice)
      await saveToken(loginModel.accessToken, loginModel.accessToken);
      log(loginModel.accessToken);
      return loginModel;
    } on DioException catch (e) {
      debugPrint('Login DioException: ${e.response?.data}');
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Login failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Login general error: $e');
      throw Exception('Login failed: $e');
    }
  }

  Future<LoginRegisterModel> register(
    String email,
    String password,
    String fullName,
    String phone,
  ) async {
    try {
      // DON'T send token for registration - this is a public endpoint
      final response = await Dio().post(
        ApiServices.register,
        data: {
          'email': email,
          'password': password,
          'fullName': fullName,
          'phone': phone, // Make sure this matches your API expectation
        },
        // Remove the Authorization header for registration
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Registration response: ${response.data}');
      return LoginRegisterModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Registration DioException: ${e.response?.data}');
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Registration failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Registration general error: $e');
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clearAllTokens();
    debugPrint('User logged out - all tokens cleared');
  }

  // Add method to check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<ForgotPasswordModel> forgotPassword(String email) async {
    try {
      final response = await Dio().post(
        ApiServices.forgotPassword,
        data: {
          'email': email,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return ForgotPasswordModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Forgot password error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Failed to send OTP');
    }
  }

  Future<VerifyModel> verifyCode({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await Dio().post(
        ApiServices.verify,
        data: {
          'email': email,
          'enteredCode': code,
          'newPassword': newPassword,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return VerifyModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Verify code error: ${e.response?.data}');
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Password reset failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }
}
