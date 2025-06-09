import 'package:eventsolutions/model/auth_model/change_password_model.dart';
import 'package:eventsolutions/model/auth_model/forgot_password_model.dart';
import 'package:eventsolutions/model/auth_model/google_model.dart';
import 'package:eventsolutions/model/auth_model/organization_google_model.dart';
import 'package:eventsolutions/model/auth_model/user_details_model.dart';
import 'package:eventsolutions/model/user_update_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventsolutions/model/auth_model/login_model.dart';
import 'package:eventsolutions/model/auth_model/register_model.dart';

import 'package:eventsolutions/services/auth_services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final loginProvider =
    FutureProvider.family<LoginModel, Map<String, String>>((ref, credentials) {
  final authService = ref.read(authServiceProvider);
  return authService.login(
    credentials['email']!,
    credentials['password']!,
  );
});

final registerProvider =
    FutureProvider.family<LoginRegisterModel, Map<String, String>>((ref, data) {
  final authService = ref.read(authServiceProvider);
  return authService.register(
      data['email']!, data['password']!, data['fullName']!, data['number']!);
});

final googleSignInProvider =
    FutureProvider.family<GoogleData, Map<String, String>>((ref, data) {
  final authService = ref.read(authServiceProvider);
  return authService.googleSignIn(
    email: data['email']!,
    fullName: data['fullName']!,
    googleId: data['uid']!,
  );
});
final organizationGoogleSignInProvider =
    FutureProvider.family<OrganizationGoogleData, Map<String, String>>(
        (ref, data) {
  final authService = ref.read(authServiceProvider);
  return authService.organizationGoogleSignIn(
    email: data['email']!,
    fullName: data['fullName']!,
    googleId: data['uid']!,
  );
});

final forgotPasswordProvider =
    FutureProvider.family<ForgotPasswordModel, String>((ref, email) {
  final authService = ref.read(authServiceProvider);
  return authService.forgotPassword(email);
});

final changePasswordProvider =
    FutureProvider.family<ChangePasswordModel, Map<String, String>>(
        (ref, data) {
  final authService = ref.read(authServiceProvider);
  return authService.changePassword(
    data['oldPassword']!,
    data['newPassword']!,
    data['confirmPassword']!,
  );
});

final userDetailsProvider = FutureProvider<UserDetailsModel>((ref) async {
  final authService = ref.read(authServiceProvider);

  final isLoggedIn = await authService.isLoggedIn();
  if (!isLoggedIn) {
    throw Exception('User is not logged in');
  }
  return await authService.getUserDetails();
});

final userUpdateStateProvider =
    StateNotifierProvider<UserUpdateNotifier, AsyncValue<UpdateResponseModel?>>(
        (ref) {
  return UserUpdateNotifier(ref);
});

class UserUpdateNotifier
    extends StateNotifier<AsyncValue<UpdateResponseModel?>> {
  final Ref ref;

  UserUpdateNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<bool> updateUser(UserUpdateModel userUpdate) async {
    state = const AsyncValue.loading();

    try {
      final authService = ref.read(authServiceProvider);
      final response = await authService.updateUserDetails(userUpdate);

      state = AsyncValue.data(response);

      if (response.success) {
        // Refresh user details after successful update
        ref.invalidate(userDetailsProvider);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }
}
