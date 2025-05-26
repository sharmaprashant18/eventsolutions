import 'package:eventsolutions/model/events/upcoming.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:eventsolutions/view/entry_form.dart';
import 'package:eventsolutions/view/upcoming_entry_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpcomingEvents extends ConsumerWidget {
  const UpcomingEvents({super.key});

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

    // Get last two digits of year
    String year = (dateTime.year % 100).toString().padLeft(2, '0');

    return '$day $month, $year';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingEvents = ref.watch(upcomingEventProvider);
    final baseUrlImage = 'http://182.93.94.210:8000';
    return Container(
        color: const Color(0xffF4F4F4),
        child: upcomingEvents.when(
          data: (upcomingevents) => ListView.builder(
            scrollDirection: Axis.vertical,

            // physics: CarouselScrollPhysics(),
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: upcomingevents.length,
            itemBuilder: (context, index) {
              final upcomingevent = upcomingevents[index];
              return ongoingEvents(
                  context,
                  '$baseUrlImage${upcomingevent.poster!}',
                  upcomingevent.title,
                  '${formatDateManually(DateTime.parse(upcomingevent.startDate))}-${formatDateManually(DateTime.parse(upcomingevent.endDate))}',
                  upcomingevent.location,
                  upcomingevent.ticketTiers[0].price.toString(),
                  upcomingevent);
            },
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ));
  }

  Widget ongoingEvents(
      BuildContext context,
      String image,
      String title,
      String date,
      String locationText,
      String price,
      UpcomingData upcomingEvent) {
    return Card(
      margin: const EdgeInsets.only(bottom: 25),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.transparent)),
      child: SizedBox(
        height: 79,
        child: Row(
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
                    SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.orange),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          locationText,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            VerticalDivider(
              indent: 10,
              endIndent: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Column(
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
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EntryForm(eventData: upcomingEvent);
                      }));
                    },
                    child: Text(
                      'JOIN NOW',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
