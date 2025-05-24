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
import 'package:eventsolutions/model/contact_us_model.dart';
import 'package:eventsolutions/model/event_register_model.dart';
import 'package:eventsolutions/model/state/event_register_state.dart';
import 'package:eventsolutions/model/ticket_model.dart';
import 'package:eventsolutions/services/event_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Event Service
final eventServiceProvider = Provider<EventServices>((ref) {
  return EventServices();
});

//List of event data
final eventProvider = FutureProvider<List<Data>>((ref) async {
  final event = ref.watch(eventServiceProvider);
  try {
    return await event.fetchEvents();
  } catch (e) {
    debugPrint('Error fetching events: $e');
    return [];
  }
});

//ticket
final ticketProvider =
    FutureProvider.family<TicketData, String>((ref, ticketId) async {
  final ticket = ref.watch(eventServiceProvider);
  final response = await ticket.fetchTicketDetails(ticketId);
  return response.data;
});

//contactus
final contactusProvider =
    FutureProvider.family<ContactUsModel, Map<String, dynamic>>((ref, data) {
  final contactService = ref.read(eventServiceProvider);
  return contactService.register(
      data['email']!, data['name']!, data['message']);
});

//selected tierprovider
final selectedTierProvider = StateProvider<String?>((ref) => null);

//event register
class RegisterEventNotifier extends StateNotifier<RegisterEventState> {
  final EventServices _eventServices;

  RegisterEventNotifier(this._eventServices) : super(RegisterEventState());

  Future<void> registerEvent({
    required String email,
    required String name,
    required String number,
    required String tierName,
    required File paymentScreenshot,
    required String eventId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _eventServices.registerEvent(
        email,
        name,
        number,
        tierName,
        paymentScreenshot,
        eventId,
      );
      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchTicketDetails(String ticketId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final ticketModel = await _eventServices.fetchTicketDetails(ticketId);
      // Convert TicketModel to EventRegisterModel if possible, or assign null if not applicable
      EventRegisterModel? eventRegisterModel;
      if (ticketModel is EventRegisterModel) {
        eventRegisterModel = ticketModel as EventRegisterModel?;
      } else {
        eventRegisterModel = null;
      }
      state =
          state.copyWith(isLoading: false, ticketDetails: eventRegisterModel);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final registerEventProvider =
    StateNotifierProvider<RegisterEventNotifier, RegisterEventState>((ref) {
  final eventService = ref.watch(eventServiceProvider);
  return RegisterEventNotifier(eventService);
});
