import 'package:eventsolutions/services/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStatusProvider = FutureProvider<bool>((ref) async {
  final token = await TokenStorage().getAccessToken();
  return token != null;
});
