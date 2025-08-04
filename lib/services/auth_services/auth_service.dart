import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:eventsolutions/api.dart';
import 'package:eventsolutions/model/auth_model/change_password_model.dart';
import 'package:eventsolutions/model/auth_model/forgot_password_model.dart';
import 'package:eventsolutions/model/auth_model/google_model.dart';
import 'package:eventsolutions/model/auth_model/organization_google_model.dart';
import 'package:eventsolutions/model/auth_model/organization_register_model.dart';
import 'package:eventsolutions/model/auth_model/user_details_model.dart';
import 'package:eventsolutions/model/auth_model/verify_email_signup.dart';
import 'package:eventsolutions/model/auth_model/verify_model.dart';
import 'package:eventsolutions/model/user_update_model.dart';
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
    String fullName,
    String phone,
    String email,
    String password,
  ) async {
    try {
      final response = await Dio().post(
        ApiServices.register,
        data: {
          'fullName': fullName,
          'phone': phone,
          'email': email,
          'password': password,
        },
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

  Future<OrganizationRegisterModel> organizationRegister(
    String fullName,
    String phone,
    String email,
    String password,
  ) async {
    try {
      final response = await Dio().post(
        ApiServices.orgRegister,
        data: {
          'email': email,
          'password': password,
          'name': fullName,
          'phone': phone,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Registration response: ${response.data}');
      return OrganizationRegisterModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Organization Registration DioException: ${e.response?.data}');
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Registration failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Organization Registration general error: $e');
      throw Exception('Organization Registration failed: $e');
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

  Future<ChangePasswordModel> changePassword(
      String oldPassword, String newPassword, String confirmPassword) async {
    try {
      // Get the access token for authentication
      final token = await _tokenStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found. Please login again.');
      }

      final response = await Dio().post(
        ApiServices.changePassword,
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': confirmPassword,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Add authorization header
          },
        ),
      );

      debugPrint('Change password response: ${response.data}');
      return ChangePasswordModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Change password error: ${e.response?.data}');
      if (e.response != null) {
        // Handle specific error messages from the server
        final errorMessage = e.response?.data['message'] ??
            e.response?.data['error'] ??
            'Failed to change password';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Unexpected change password error: $e');
      throw Exception('Failed to change password: $e');
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

  Future<VerifyEmailSignupModel> verifyEmailCodeSignup({
    required String email,
    required String code,
  }) async {
    try {
      final response = await Dio().post(
        ApiServices.verifyEmail,
        data: {
          'email': email,
          'code': code,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return VerifyEmailSignupModel.fromJson(response.data);
    } on DioException catch (e) {
      debugPrint('Verify code error: ${e.response?.data}');
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Verification failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<UserDetailsModel> getUserDetails() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      final response = await Dio().get(
        ApiServices.mydetails,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      debugPrint("User details response: ${response.data}");

      return UserDetailsModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      debugPrint('Get user details error: ${e.response?.data}');
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to fetch user details');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      throw Exception('Failed to fetch user details: $e');
    }
  }

  Future<UpdateResponseModel> updateUserDetails(
      UserUpdateModel userUpdate) async {
    try {
      final token = await _tokenStorage.getAccessToken();
      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      final response = await Dio().post(
        ApiServices.changeDetails,
        data: userUpdate.toJson(),
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        }),
      );

      // Check if the server provided a new token (after email update)
      if (response.data['accessToken'] != null) {
        await saveToken(
            response.data['accessToken'], response.data['accessToken']);
      }

      return UpdateResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.data != null) {
        return UpdateResponseModel.fromJson(e.response!.data);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<GoogleData> googleSignIn({
    required String email,
    required String fullName,
    required String googleId,
  }) async {
    try {
      final response = await Dio().post(
        ApiServices.googleSign,
        data: {
          'email': email,
          'fullName': fullName,
          'uid': googleId,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      final googleData = GoogleData.fromJson(response.data);
      await saveToken(googleData.accessToken, googleData.accessToken);
      return googleData;
    } on DioException catch (e) {
      debugPrint('Google sign-in error: ${e.response?.data}');
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Google sign-in failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    }
  }

  Future<OrganizationGoogleData> organizationGoogleSignIn({
    required String email,
    required String fullName,
    required String googleId,
  }) async {
    try {
      final response = await Dio().post(
        ApiServices.orgGoogleSign,
        data: {
          'email': email,
          'fullName': fullName,
          'uid': googleId,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Google sign-in response: ${response.data}');

      final googleData = OrganizationGoogleData.fromJson(response.data);

      // Save token for both access and refresh (if same)
      await saveToken(googleData.accessToken, googleData.accessToken);

      return googleData;
    } on DioException catch (e) {
      debugPrint('Google sign-in DioException: ${e.response?.data}');
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Google sign-in failed');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      debugPrint('Google sign-in general error: $e');
      throw Exception('Google sign-in failed: $e');
    }
  }
}
