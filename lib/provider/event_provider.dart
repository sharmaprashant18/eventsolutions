// ignore_for_file: use_build_context_synchronously
import 'package:eventsolutions/model/events/all_events_model.dart';
import 'package:eventsolutions/model/event_register_model.dart';
import 'package:eventsolutions/model/events/ongoing.dart';
import 'package:eventsolutions/model/events/other_events_model.dart';
import 'package:eventsolutions/model/events/reedem_ticket_features_model.dart';
import 'package:eventsolutions/model/events/ticket_features_model.dart';
import 'package:eventsolutions/model/events/upcoming.dart';
import 'package:eventsolutions/model/our_team_model.dart';
import 'package:eventsolutions/services/event_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Event Service
final eventServiceProvider = Provider<EventServices>((ref) {
  return EventServices();
});

// List of allevent data
final eventProvider = FutureProvider<List<Data>>((ref) async {
  final event = ref.watch(eventServiceProvider);
  try {
    return await event.fetchEvents();
  } catch (e) {
    debugPrint('Error fetching events: $e');
    return [];
  }
});

//ongoingevents

final ongoingEventProvider = FutureProvider<List<OngoingData>>((ref) async {
  final event = ref.watch(eventServiceProvider);
  try {
    return await event.fetchOngoingEvents();
  } catch (e) {
    debugPrint('Error fetching events: $e');
    return [];
  }
});

//upcoming events

final upcomingEventProvider = FutureProvider<List<UpcomingData>>((ref) async {
  final event = ref.watch(eventServiceProvider);
  try {
    return await event.fetchUpcomingEvents();
  } catch (e) {
    debugPrint('Error fetching events: $e');
    return [];
  }
});

// Selected tier provider
final selectedTierProvider = StateProvider<String?>((ref) => null);

// register_tickets
final registerEventProvider =
    FutureProvider.family<RegistrationData, Map<String, dynamic>>(
        (ref, data) async {
  final ticketService = ref.read(eventServiceProvider);
  return await ticketService.registerEvent(
    data['email']!,
    data['name']!,
    data['number']!,
    data['tierName']!,
    data['paymentScreenshot']!,
    data['eventId']!,
  );
});

final ticketfeaturesProvider =
    FutureProvider.family<List<TicketFeaturesModel>, String>(
        (ref, ticketId) async {
  final featureservice = ref.watch(eventServiceProvider);
  return await featureservice.getTicketFeaturesByTicketId(ticketId);
});

final reedemTicketfeaturesProvider = FutureProvider.family<
    List<RedeemTicketFeaturesModel>,
    ({String ticketId, String featureName})>((ref, params) async {
  final reedemTicketFeaturesService = ref.watch(eventServiceProvider);
  return await reedemTicketFeaturesService.redeemTicketFeaturesByTicketId(
      params.ticketId, params.featureName);
});

final otherEventsProvider = FutureProvider<List<OtherEventsModel>>((ref) async {
  final otherEventsService = ref.watch(eventServiceProvider);
  return otherEventsService.fetchOtherEvents();
});

final teamProvider = FutureProvider<List<OurTeamModel>>((ref) async {
  final teamMemberService = ref.watch(eventServiceProvider);
  return teamMemberService.fetchOurTeam();
});
