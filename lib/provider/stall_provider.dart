import 'dart:developer';

import 'package:eventsolutions/model/stall/hold_stall_model.dart';
import 'package:eventsolutions/model/stall/one_stall_model.dart';
import 'package:eventsolutions/model/stall/stall_booking_model.dart';
import 'package:eventsolutions/model/stall/stall_model.dart';
import 'package:eventsolutions/services/stalls_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final stallServiceProvider = Provider<StallsServices>((ref) {
  return StallsServices();
});

// Provider to fetch stalls for a specific event
final stallProvider =
    FutureProvider.family<StallData, String>((ref, eventId) async {
  final stallService = ref.watch(stallServiceProvider);
  try {
    return await stallService.fetchStalls(eventId);
  } catch (e) {
    log('Error fetching stalls: $e', name: 'StallProvider');
    throw Exception('Error fetching stalls: $e');
  }
});

// Provider to fetch a specific stall by its ID
final stallByIdProvider =
    FutureProvider.family<StallModelById, String>((ref, stallId) async {
  final stallService = ref.watch(stallServiceProvider);
  try {
    return await stallService.fetchStallByID(stallId);
  } catch (e) {
    log('Error fetching stall by ID: $e', name: 'StallByIdProvider');
    throw Exception('Error fetching stall by ID: $e');
  }
});

final stallBookingProvider =
    FutureProvider.family<StallBookingModel, Map<String, dynamic>>(
        (ref, data) async {
  final stallService = ref.watch(stallServiceProvider);
  try {
    return await stallService.bookStall(
      data['stallId']!,
      data['businessName']!,
      data['businessPhone']!,
      data['businessEmail']!,
      data['contactPersonName']!,
      data['contactPersonPhone']!,
      data['contactPersonEmail']!,
      data['paymentProof']!,
    );
  } catch (e) {
    log('Error booking stall: $e', name: 'StallBookingProvider');
    throw Exception('Error booking stall: $e');
  }
});

final stallHoldProvider =
    FutureProvider.family<HoldstallModel, Map<String, dynamic>>(
        (ref, data) async {
  final stallService = ref.watch(stallServiceProvider);

  try {
    return await stallService.holdStall(
      data['stallId']!,
      data['businessName']!,
      data['businessPhone']!,
      data['businessEmail']!,
      data['contactPersonName']!,
      data['contactPersonEmail']!,
      data['contactPersonPhone']!,
    );
  } catch (e) {
    log('Error holding stall: $e', name: 'StallHoldProvider');
    throw Exception('Error holding stall: $e');
  }
});
