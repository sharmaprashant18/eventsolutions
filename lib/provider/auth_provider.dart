import 'package:eventsolutions/model/forgot_password_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventsolutions/model/login_model.dart';
import 'package:eventsolutions/model/register_model.dart';

import 'package:eventsolutions/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final loginProvider =
    FutureProvider.family<LoginModel, Map<String, String>>((ref, credentials) {
  final authService = ref.read(authServiceProvider);
  return authService.login(credentials['email']!, credentials['password']!);
});

final registerProvider =
    FutureProvider.family<LoginRegisterModel, Map<String, String>>((ref, data) {
  final authService = ref.read(authServiceProvider);
  return authService.register(data['email']!, data['password']!);
});

final forgotPasswordProvider =
    FutureProvider.family<ForgotPasswordModel, String>((ref, email) {
  final authService = ref.read(authServiceProvider);
  return authService.forgotPassword(email);
});

// final forgotPasswordProvider =
//     FutureProvider.family<void, String>((ref, email) {
//   final authService = ref.read(authServiceProvider);

//   return authService.forgotPassword(email);
// });
