import 'dart:developer';

import 'package:eventsolutions/model/stall_model.dart';
import 'package:eventsolutions/services/stalls_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stallServiceProvider = Provider<StallsServices>((ref) {
  return StallsServices();
});

final stallProvider = FutureProvider<List<StallModel>>((ref) async {
  final stallService = ref.watch(stallServiceProvider);
  try {
    return await stallService.fetchStalls();
  } catch (e) {
    log('Error fetching stalls: $e', name: 'StallProvider');
    throw Exception('Error fetching stalls: $e');
  }
});
