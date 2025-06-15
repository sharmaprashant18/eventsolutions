// ignore_for_file: use_build_context_synchronously
import 'package:eventsolutions/model/auth_model/user_details_model.dart';
import 'package:eventsolutions/model/events/upcoming.dart';
import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:eventsolutions/view/entry_form.dart';
import 'package:eventsolutions/view/stall_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpcomingEvents extends ConsumerStatefulWidget {
  const UpcomingEvents({super.key, required this.searchQuery});
  final String searchQuery;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends ConsumerState<UpcomingEvents> {
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
    final userDetails = ref.watch(userDetailsProvider); // Fetch user details
    final baseUrlImage = 'http://182.93.94.210:8000';

    return Container(
      color: const Color(0xffF4F4F4),
      child: upcomingEvents.when(
        data: (upcomingevents) {
          final filteredEvents = upcomingevents
              .where((event) =>
                  event.title
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()) ||
                  event.location
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()))
              .toList();

          if (filteredEvents.isEmpty) {
            return const Center(child: Text('No events match your search.'));
          }

          return ListView.builder(
            scrollDirection: Axis.vertical,
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final upcomingevent = filteredEvents[index];
              return ongoingEvents(
                context,
                '$baseUrlImage${upcomingevent.poster}',
                upcomingevent.title,
                '${formatDateManually(DateTime.parse(upcomingevent.startDate))}-${formatDateManually(DateTime.parse(upcomingevent.endDate))}',
                upcomingevent.location,
                // upcomingevent.ticketTiers[0].price.toString(),
                upcomingevent.ticketTiers.isNotEmpty
                    ? upcomingevent.ticketTiers[0].price.toString()
                    : 'N/A',
                upcomingevent.hasStalls,
                upcomingevent,
                userDetails, // Pass user details to ongoingEvents
              );
            },
          );
        },
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
    bool hasStalls,
    UpcomingData upcomingEvent,
    AsyncValue<UserDetailsModel> userDetails,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 25),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.transparent),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    image,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                userDetails.when(
                  data: (user) {
                    if (user.role == 'organization' && hasStalls) {
                      return Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return StallPage(
                                    eventId: upcomingEvent.eventId.toString());
                              }));
                            },
                            child: Text(
                              'BOOK STALL',
                              style: TextStyle(
                                color: Color(0xff667EEA),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else if (user.role == 'organization' && !hasStalls) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'No stalls available',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (err, stack) => const SizedBox.shrink(),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Container(
                        height: 30,
                        width: 4,
                        color: Colors.grey.shade200,
                      ),
                      const Spacer(),
                      // Text(
                      //   'Rs:$price',
                      //   style: const TextStyle(
                      //     color: Colors.orange,
                      //     fontWeight: FontWeight.w700,
                      //   ),
                      // ),
                      userDetails.when(
                        data: (user) {
                          if (user.role == 'user') {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return EntryForm(eventData: upcomingEvent);
                                  }),
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
                            );
                          }
                          return SizedBox
                              .shrink(); // No button for organization
                        },
                        loading: () => const SizedBox.shrink(),
                        error: (err, stack) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          FittedBox(
                            child: Text(
                              locationText,
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
