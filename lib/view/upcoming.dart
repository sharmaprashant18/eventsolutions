import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eventsolutions/model/all_events_model.dart';
import 'package:eventsolutions/provider/event/eventProvider.dart';
import 'package:eventsolutions/view/entry_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpcomingPage extends ConsumerStatefulWidget {
  const UpcomingPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends ConsumerState<UpcomingPage> {
  final baseUrlImage = 'http://182.93.94.210:8000';
  String formatDateManually(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '');

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

    return '$day $month';
  }

  late StreamSubscription<List<ConnectivityResult>> subscription;
  bool wasOffline = false;
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
        ref.invalidate(eventProvider);
      } else if (!hasConnection) {
        wasOffline = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No Internet Connection',
              style: TextStyle(
                  color: Colors.red,
                  backgroundColor: Colors.white,
                  fontSize: 16)),
          duration: Duration(seconds: 10),
        ));
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final event = ref.watch(eventProvider);
    return Scaffold(
      body: event.when(
          data: (event) {
            if (event.isEmpty) {
              return Center(
                child: Text('No Event Available'),
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.008,
                right: screenWidth * 0.03,
                left: screenWidth * 0.03,
              ),
              child: ListView.builder(
                itemCount: event.length,
                itemBuilder: (context, index) {
                  final events = event[index];
                  return Card(
                    // color: Colors.blueGrey,
                    color: Colors.white,
                    shadowColor: Colors.grey.withAlpha(10),
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(
                            width: 0,
                            style: BorderStyle.solid,
                            color: Colors.grey)),
                    clipBehavior: Clip.antiAlias,
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //Event Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: (events.poster != null &&
                                    events.poster!.isNotEmpty)
                                ? Image.network(
                                    '$baseUrlImage${events.poster}',
                                    height: screenHeight * 0.2,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset('assets/event1.png');
                                    },
                                  )
                                : Image.asset(
                                    'assets/event1.png',
                                    height: screenHeight * 0.2,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                          ),

                          // Content
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              SizedBox(
                                height: 6,
                              ),
                              FittedBox(
                                child: Text(
                                  events.title,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      fontSize: 16,
                                      color: Colors.black87),
                                ),
                              ),
                              SizedBox(height: 12),
                              // Date and Location row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Date
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month,
                                          color: Color(0xffF66B10)),
                                      SizedBox(width: 4),
                                      Text(
                                        '${formatDateManually(DateTime.parse(events.startDate))}-${formatDateManually(DateTime.parse(events.endDate))}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Location
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          color: Color(0xffF77018)),
                                      SizedBox(width: 4),
                                      Text(
                                        'Kathmandu Nepal',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Price: Rs${events.ticketTiers[0].price.toStringAsFixed(2)}',
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                  Spacer(),
                                  // Join button
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => EntryForm(
                                                    events: events,
                                                  )));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      // backgroundColor: Color(0xff35353E),
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 26, vertical: 0),
                                    ),
                                    child: Text(
                                      'JOIN NOW',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text('Error:$error'),
            );
          },
          loading: () => Center(
                child: CircularProgressIndicator(),
              )),
    );
  }
}
