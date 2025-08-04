import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventsolutions/constants/refresh_indicator.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:eventsolutions/view/event_by_id.dart';
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

    return RefreshScaffold(
      onRefresh: () async {
        ref.invalidate(otherEventsProvider);
        await Future.delayed(Duration(seconds: 2));
      },
      body: otherEvents.when(
        data: (otherEventdata) {
          if (otherEventdata.isEmpty) {
            // Wrap in scrollable widget
            return const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400, // Give it some height
                child: Center(
                  child: Text(
                    'No events available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
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
            // Wrap in scrollable widget
            return const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400, // Give it some height
                child: Center(
                  child: Text(
                    'No events available according to your search.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return EventById(eventId: event.eventId);
                  }));
                },
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: CachedNetworkImage(
                          imageUrl: '$baseUrlImage${event.poster}',
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) =>
                              Container(
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
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Date
                                  Expanded(
                                    child: Container(
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            width: 6, color: Color(0xffF4F5FC)),
                                        color: Color(0xffF4F5FC),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF667EEA)
                                                        .withAlpha(30),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Icon(
                                                      Icons.calendar_month,
                                                      color:
                                                          // Color(0xff667EEA)
                                                          Color(0xff0a519d)),
                                                ),
                                                SizedBox(width: 7),
                                                Text(
                                                  'Date',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          // Color(0xff667EEA)
                                                          Color(0xff0a519d)),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${formatDateManually(DateTime.parse(event.startDateTime))}-${formatDateManually(DateTime.parse(event.endDateTime))}',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  formatDateManually(
                                                    DateTime.parse(
                                                        event.endDateTime),
                                                    yearOnly: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  // Location
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            width: 6, color: Color(0xffF9F2F3)),
                                        color: Color(0xffF9F2F3),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFF56565)
                                                        .withAlpha(30),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Icon(
                                                    Icons.location_on_outlined,
                                                    color:
                                                        // Color(0xffF77018)
                                                        Color(0xffe92429),
                                                  ),
                                                ),
                                                SizedBox(width: 7),
                                                Text(
                                                  'Location',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        // Color(0xffF77018)
                                                        Color(0xffe92429),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              event.location,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        error: (error, stackTrace) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Image.asset('assets/wrong.png'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(otherEventsProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
        loading: () => const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 400,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
