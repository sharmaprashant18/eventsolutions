import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eventsolutions/abstract/event_data.dart';
import 'package:eventsolutions/provider/event/event_provider.dart';
import 'package:eventsolutions/view/entry_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpcomingEvents extends ConsumerStatefulWidget {
  const UpcomingEvents({super.key});

  @override
  ConsumerState<UpcomingEvents> createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends ConsumerState<UpcomingEvents> {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool wasOffline = false;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      final hasConnection = result.any((result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet);

      if (hasConnection && wasOffline) {
        wasOffline = false;
        ref.invalidate(upcomingEventProvider);
      } else if (!hasConnection) {
        wasOffline = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No Internet Connection',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            duration: Duration(seconds: 10),
            backgroundColor: Colors.white,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  String formatDateManually(DateTime dateTime) {
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
    String year = (dateTime.year % 100).toString().padLeft(2, '0');
    return '$day $month, $year';
  }

  @override
  Widget build(BuildContext context) {
    final upcomingEvents = ref.watch(upcomingEventProvider);
    final baseUrlImage = 'http://182.93.94.210:8000';

    return Container(
      color: const Color(0xffF4F4F4),
      child: upcomingEvents.when(
        data: (upcomingEvents) => upcomingEvents.isEmpty
            ? const Center(child: Text('No Upcoming Events Available'))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: upcomingEvents.length,
                itemBuilder: (context, index) {
                  final upcomingEvent = upcomingEvents[index];
                  return ongoingEvents(
                    context,
                    upcomingEvent.poster != null &&
                            upcomingEvent.poster!.isNotEmpty
                        ? '$baseUrlImage${upcomingEvent.poster}'
                        : '',
                    upcomingEvent.title,
                    formatDateManually(DateTime.parse(upcomingEvent.startDate)),
                    'Kathmandu, Nepal',
                    upcomingEvent.ticketTiers.isNotEmpty
                        ? 'Rs${upcomingEvent.ticketTiers[0].price.toStringAsFixed(2)}'
                        : 'N/A',
                    upcomingEvent,
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget ongoingEvents(
    BuildContext context,
    String image,
    String title,
    String date,
    String locationText,
    String price,
    EventData eventData,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 25),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.transparent),
      ),
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'assets/event1.png',
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      'assets/event1.png',
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 5),
                        FittedBox(
                          child: Text(
                            locationText,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const VerticalDivider(
              indent: 10,
              endIndent: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntryForm(eventData: eventData),
                      ),
                    );
                  },
                  child: const Text(
                    'JOIN NOW',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
