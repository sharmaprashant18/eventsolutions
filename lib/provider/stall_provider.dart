import 'dart:developer';

import 'package:eventsolutions/model/stall/hold_stall_model.dart';
import 'package:eventsolutions/model/stall/one_stall_model.dart';
import 'package:eventsolutions/model/stall/pay_again_model.dart';
import 'package:eventsolutions/model/stall/stall_booking_model.dart';
import 'package:eventsolutions/model/stall/stall_model.dart';
import 'package:eventsolutions/model/stall/user_booking_details_model.dart';
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

// Provider to fetch the user booking details
final userBookingdetailsProvider =
    FutureProvider<List<UserBookingDetailsModel>>((ref) async {
  final stallService = ref.watch(stallServiceProvider);
  try {
    return await stallService.fetchUserBooking();
  } catch (e) {
    log('Error fetching user booking details: $e',
        name: 'UserBookingDetailsProvider');
    throw Exception('Error fetching user booking details: $e');
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

final multipleStallBookingProvider =
    FutureProvider.family<MultipleStallBookingModel, Map<String, dynamic>>(
  (ref, data) async {
    final stallService = ref.watch(stallServiceProvider);
    try {
      final stallIds = data['stallIds'] is String
          ? [data['stallIds'] as String]
          : data['stallIds'] as List<String>;
      return await stallService.bookStall(
          stallIds,
          data['businessName']!,
          data['businessPhone']!,
          data['businessEmail']!,
          data['contactPersonName']!,
          data['contactPersonPhone']!,
          data['contactPersonEmail']!,
          data['paymentProof']!,
          data['paidAmount']!,
          data['paymentMethod']!);
    } catch (e) {
      log('Error booking stall: $e', name: 'StallBookingProvider');
      throw Exception('Error booking stall: $e');
    }
  },
);

final multipleStallHoldProvider =
    FutureProvider.family<MultipleStallHoldingModel, Map<String, dynamic>>(
        (ref, holdingData) async {
  return await StallsServices().holdMultipleStall(
    holdingData['stallIds'] as List<String>,
    holdingData['contactPersonName']!,
    holdingData['contactPersonNumber']!,
    holdingData['contactPersonEmail']!,
  );
});

final payAgainProvider =
    FutureProvider.family<PayAgainModel, Map<String, dynamic>>(
        (ref, payingData) async {
  return await StallsServices().payagain(
    payingData['bookingId'],
    payingData['paidAmount']!,
    payingData['paymentMethod']!,
    payingData['paymentProof']!,
  );
});
