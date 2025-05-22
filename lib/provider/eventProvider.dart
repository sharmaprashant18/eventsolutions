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

import 'package:eventsolutions/model/all_events_model.dart';
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
    return []; // Return empty list as fallback
  }
});
