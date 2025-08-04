// ignore_for_file: use_build_context_synchronously
import 'package:eventsolutions/model/events/all_events_model.dart';
import 'package:eventsolutions/model/event_register_model.dart';
import 'package:eventsolutions/model/events/event_by_event_id.dart';
import 'package:eventsolutions/model/events/ongoing.dart';
import 'package:eventsolutions/model/events/other_events_model.dart';
import 'package:eventsolutions/model/events/reedem_ticket_features_model.dart';
import 'package:eventsolutions/model/events/ticket_features_model.dart';
import 'package:eventsolutions/model/events/upcoming.dart';
import 'package:eventsolutions/model/our_team_model.dart';
import 'package:eventsolutions/model/qr_code.dart';
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

//eventByEventId
final eventByEventIdProvider =
    FutureProvider.family<EventByEventId, String>((ref, eventId) async {
  final event = ref.watch(eventServiceProvider);
  try {
    return await event.fetchEventByEventId(eventId);
  } catch (e) {
    debugPrint('Error fetching events: $e');
    throw Exception('Error fetching event by ID: $e');
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

final registerEventProvider =
    FutureProvider.family<RegistrationData, Map<String, dynamic>>(
        (ref, data) async {
  final ticketService = ref.read(eventServiceProvider);

  final paymentScreenshot = data['paymentScreenshot'];

  return await ticketService.registerEvent(
    data['email']!,
    data['name']!,
    data['number']!,
    data['tierName']!,
    paymentScreenshot,
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
  return await otherEventsService.fetchOtherEvents();
});

final teamProvider = FutureProvider<List<OurTeamModel>>((ref) async {
  final teamMemberService = ref.watch(eventServiceProvider);
  return await teamMemberService.fetchOurTeam();
});
final qrProvider = FutureProvider<List<QrCodeModel>>((ref) async {
  final qr = ref.watch(eventServiceProvider);
  return await qr.getQrCode();
});

// Entry status tracking for each ticket
final entryStatusProvider =
    StateNotifierProvider.family<EntryStatusNotifier, EntryStatus, String>(
  (ref, ticketId) => EntryStatusNotifier(ticketId),
);

// QR Scanner state provider
final qrScannerStateProvider =
    StateNotifierProvider<QrScannerStateNotifier, QrScannerState>(
  (ref) => QrScannerStateNotifier(),
);

// Entry status enum and class
enum EntryState {
  initial, // Not scanned yet
  firstScan, // First scan detected (entry: false)
  processing, // Processing entry
  entryCompleted, // Entry completed (entry: true), showing dialog
  readyForFeatures, // Ready to show features
  error
}

class EntryStatus {
  final EntryState state;
  final bool hasEntry;
  final String? errorMessage;

  EntryStatus({
    required this.state,
    required this.hasEntry,
    this.errorMessage,
  });

  EntryStatus copyWith({
    EntryState? state,
    bool? hasEntry,
    String? errorMessage,
  }) {
    return EntryStatus(
      state: state ?? this.state,
      hasEntry: hasEntry ?? this.hasEntry,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class EntryStatusNotifier extends StateNotifier<EntryStatus> {
  final String ticketId;

  EntryStatusNotifier(this.ticketId)
      : super(EntryStatus(state: EntryState.initial, hasEntry: false));

  Future<void> processQRScan() async {
    try {
      state = state.copyWith(state: EntryState.processing);

      final eventService = EventServices();
      final features = await eventService.getTicketFeaturesByTicketId(ticketId);

      // This means we got the actual features list
      state = state.copyWith(
        state: EntryState.readyForFeatures,
        hasEntry: true,
      );
    } catch (e) {
      if (e.toString().contains('Entry not allowed')) {
        // First scan - entry is false
        state = state.copyWith(
          state: EntryState.firstScan,
          hasEntry: false,
        );
      } else if (e.toString().contains('Entry true - printing ticket')) {
        // Entry just became true, show printing dialog
        state = state.copyWith(
          state: EntryState.entryCompleted,
          hasEntry: true,
        );
      } else {
        state = state.copyWith(
          state: EntryState.error,
          errorMessage: e.toString(),
        );
      }
    }
  }

  void markEntryCompleted() {
    state = state.copyWith(state: EntryState.readyForFeatures);
  }

  void reset() {
    state = EntryStatus(state: EntryState.initial, hasEntry: false);
  }
}

// QR Scanner state management
class QrScannerState {
  final bool isScanning;
  final bool canScan;
  final String? currentTicketId;

  QrScannerState({
    required this.isScanning,
    required this.canScan,
    this.currentTicketId,
  });

  QrScannerState copyWith({
    bool? isScanning,
    bool? canScan,
    String? currentTicketId,
  }) {
    return QrScannerState(
      isScanning: isScanning ?? this.isScanning,
      canScan: canScan ?? this.canScan,
      currentTicketId: currentTicketId ?? this.currentTicketId,
    );
  }
}

class QrScannerStateNotifier extends StateNotifier<QrScannerState> {
  QrScannerStateNotifier()
      : super(QrScannerState(isScanning: false, canScan: true));

  void startScanning(String ticketId) {
    state = state.copyWith(
      isScanning: true,
      canScan: false,
      currentTicketId: ticketId,
    );
  }

  void finishScanning() {
    state = state.copyWith(
      isScanning: false,
      canScan: true,
      currentTicketId: null,
    );
  }

  void enableScanning() {
    state = state.copyWith(canScan: true);
  }

  void disableScanning() {
    state = state.copyWith(canScan: false);
  }
}
