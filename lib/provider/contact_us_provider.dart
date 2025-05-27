// Contact us provider
// ignore_for_file: use_build_context_synchronously
import 'package:eventsolutions/model/contact_us_model.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactusProvider =
    FutureProvider.family<ContactUsModel, Map<String, dynamic>>((ref, data) {
  final contactService = ref.read(eventServiceProvider);
  return contactService.register(
      data['email']!, data['name']!, data['message']!);
});
