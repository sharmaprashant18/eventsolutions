// import 'package:eventsolutions/model/all_events_model.dart';
// import 'package:eventsolutions/services/event_services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final eventServiceProvider = Provider<EventServices>((ref) {
//   return EventServices();
// });

// final eventProvider = FutureProvider<List<Data>>((ref) async {
//   final event = ref.watch(eventServiceProvider);
//   return await event.fetchEvents();
// });

import 'dart:io';

import 'package:eventsolutions/model/all_events_model.dart';
import 'package:eventsolutions/model/event_register_model.dart';
import 'package:eventsolutions/services/event_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventServiceProvider = Provider<EventServices>((ref) {
  return EventServices();
});

final eventProvider = FutureProvider<List<Data>>((ref) async {
  final event = ref.watch(eventServiceProvider);
  try {
    return await event.fetchEvents();
  } catch (e) {
    debugPrint('Error fetching events: $e');
    return [];
  }
});

final emailProvider = StateProvider<String>((ref) => '');
final nameProvider = StateProvider<String>((ref) => '');
final numberProvider = StateProvider<String>((ref) => '');
final tierProvider = StateProvider<String>((ref) => '');
final screenshotProvider = StateProvider<File?>((ref) => null);
final eventIdProvider = StateProvider<String>((ref) => '');

final registrationEventProvider =
    FutureProvider<EventRegisterModel>((ref) async {
  final service = ref.watch(eventServiceProvider);

  final email = ref.watch(emailProvider);
  final name = ref.watch(nameProvider);
  final number = ref.watch(numberProvider);
  final tierName = ref.watch(tierProvider);
  final paymentScreenshot = ref.watch(screenshotProvider);
  final eventId = ref.watch(eventIdProvider);

  if (paymentScreenshot == null) {
    throw Exception("Please upload a payment screenshot.");
  }

  return await service.registerEvent(
    email,
    name,
    number,
    tierName,
    paymentScreenshot,
    eventId,
  );
});
