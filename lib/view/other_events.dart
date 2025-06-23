import 'package:eventsolutions/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtherEvents extends ConsumerStatefulWidget {
  const OtherEvents({super.key, required this.searchQuery});
  final String searchQuery;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OtherEventsState();
}

String formatDateManually(DateTime dateTime,
    {bool includeYear = false, bool yearOnly = false}) {
  if (yearOnly) {
    return dateTime.year.toString();
  }

  String day = dateTime.day.toString().padLeft(2, '0');
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  String month = months[dateTime.month - 1];

  if (includeYear) {
    String year = dateTime.year.toString();
    return '$day $month, $year';
  }

  return '$day $month';
}

class _OtherEventsState extends ConsumerState<OtherEvents> {
  @override
  Widget build(BuildContext context) {
    final otherEvents = ref.watch(otherEventsProvider);
    final baseUrlImage = 'http://182.93.94.210:8001';
    return Scaffold(
      body: otherEvents.when(
        data: (otherEventdata) {
          if (otherEventdata.isEmpty) {
            return const Center(
              child: Text(
                'No events available',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          final filteredEvents = otherEventdata
              .where((event) =>
                  event.title
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()) ||
                  event.location
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()))
              .toList();
          if (filteredEvents.isEmpty) {
            return const Center(
              child: Text(
                'No events available according to your search.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: otherEventdata.length,
            itemBuilder: (context, index) {
              final event = otherEventdata[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        '$baseUrlImage${event.poster}',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: Center(
                            child: Icon(Icons.broken_image,
                                size: 48, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 20, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  event.location,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 20, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                '${formatDateManually(DateTime.parse(event.startDateTime))}-${formatDateManually(DateTime.parse(event.endDateTime))}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load events: $error',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(otherEventsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
