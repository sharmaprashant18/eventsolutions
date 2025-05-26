// Ticket provider
import 'package:eventsolutions/model/ticket_model.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ticketProvider =
    FutureProvider.family<TicketData, String>((ref, ticketId) async {
  final ticket = ref.watch(eventServiceProvider);
  final response = await ticket.fetchTicketDetailsById(ticketId);
  return response;
});
