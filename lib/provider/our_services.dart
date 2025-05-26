import 'package:eventsolutions/model/our_services_model.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ourServicesProvider = FutureProvider<List<OurServiceModel>>((ref) async {
  final event = ref.watch(eventServiceProvider);
  try {
    return await event.fetchOurService();
  } catch (e) {
    debugPrint('Error fetching events: $e');
    return [];
  }
});
