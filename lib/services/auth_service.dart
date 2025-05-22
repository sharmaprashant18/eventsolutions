// import 'package:dio/dio.dart';
// import 'package:eventsolutions/model/forgot_password_model.dart';
// import 'package:eventsolutions/model/verify_model.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:eventsolutions/model/login_model.dart';
// import 'package:eventsolutions/model/register_model.dart';
// import 'package:eventsolutions/services/dio_client.dart';

// class AuthService {
//   final Dio _dio = DioClient().dio;

//   // Save token to SharedPreferences
//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('access_token', token);
//   }

//   // Get token from SharedPreferences
//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('access_token');
//   }

//   Future<LoginModel> login(String email, String password) async {
//     try {
//       final response = await _dio.post('/login', data: {
//         'email': email,
//         'password': password,
//       });
//       final loginModel = LoginModel.fromJson(response.data);

//       debugPrint("Access Token: ${loginModel.accessToken}");
//       await saveToken(loginModel.accessToken);

//       return loginModel;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response?.data['message'] ?? 'Login failed');
//       } else {
//         throw Exception('Network error');
//       }
//     }
//   }

//   Future<RegisterModel> register(String email, String password) async {
//     try {
//       final response = await _dio.post('/register', data: {
//         'email': email,
//         'password': password,
//       });
//       return RegisterModel.fromJson(response.data);
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
//       final response = await _dio.post('/forget-password', data: {
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
//       final response = await _dio.post('/verify-code', data: {
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

// import 'package:eventsolutions/model/forgot_password_model.dart';
// import 'package:eventsolutions/model/verify_model.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:eventsolutions/model/login_model.dart';
// import 'package:eventsolutions/model/register_model.dart';
// import 'package:eventsolutions/services/dio_client.dart';

// class AuthService {
//   final Dio _dio = DioClient().dio;

//   // Save token to SharedPreferences
//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('access_token', token);
//   }

//   // Get token from SharedPreferences
//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('access_token');
//   }

//   Future<LoginModel> login(String email, String password) async {
//     try {
//       final response = await _dio.post('/login', data: {
//         'email': email,
//         'password': password,
//       });
//       final loginModel = LoginModel.fromJson(response.data);

//       debugPrint("Access Token: ${loginModel.accessToken}");
//       await saveToken(loginModel.accessToken);

//       return loginModel;
//     } on DioException catch (e) {
//       if (e.response != null) {
//         throw Exception(e.response?.data['message'] ?? 'Login failed');
//       } else {
//         throw Exception('Network error');
//       }
//     }
//   }

//   Future<RegisterModel> register(String email, String password) async {
//     try {
//       final response = await _dio.post('/register', data: {
//         'email': email,
//         'password': password,
//       });
//       return RegisterModel.fromJson(response.data);
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
//       final response = await _dio.post('/forget-password', data: {
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
//       final response = await _dio.post('/verify-code', data: {
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

import 'package:dio/dio.dart';
import 'package:eventsolutions/model/forgot_password_model.dart';
import 'package:eventsolutions/model/verify_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventsolutions/model/login_model.dart';
import 'package:eventsolutions/model/register_model.dart';
import 'package:eventsolutions/services/dio_client.dart';
import 'package:eventsolutions/services/token_storage.dart';

class AuthService {
  final Dio _dio = DioClient().dio;
  final TokenStorage _tokenStorage = TokenStorage();

  Future<void> saveToken(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await _tokenStorage.saveAccessToken(accessToken);
    await _tokenStorage.saveRefreshToken(refreshToken);
    debugPrint('Access and refresh tokens saved');
  }

  Future<LoginModel> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });
      final loginModel = LoginModel.fromJson(response.data);
      debugPrint("Access Token: ${loginModel.accessToken}");
      await saveToken(loginModel.accessToken,
          loginModel.accessToken); // Assume refresh token is returned
      return loginModel;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Login failed');
      } else {
        throw Exception('Network error');
      }
    }
  }

  Future<LoginRegisterModel> register(String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'email': email,
        'password': password,
      });
      return LoginRegisterModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Registration failed');
      } else {
        throw Exception('Network error');
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }

  Future<ForgotPasswordModel> forgotPassword(String email) async {
    try {
      final response = await _dio.post('/forget-password', data: {
        'email': email,
      });

      return ForgotPasswordModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to send OTP');
    }
  }

  Future<VerifyModel> verifyCode({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post('/verify-code', data: {
        'email': email,
        'enteredCode': code,
        'newPassword': newPassword,
      });

      return VerifyModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Password reset failed');
      } else {
        throw Exception('Network error');
      }
    }
  }
}
