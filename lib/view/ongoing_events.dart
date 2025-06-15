// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eventsolutions/provider/auth_provider/auth_provider.dart';
import 'package:eventsolutions/provider/event_provider.dart';
import 'package:eventsolutions/view/entry_form.dart';
import 'package:eventsolutions/view/stall_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OngoingEvents extends ConsumerStatefulWidget {
  const OngoingEvents({super.key, required this.searchQuery});
  final String searchQuery;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpcomingPageState();
}

class _UpcomingPageState extends ConsumerState<OngoingEvents> {
  final baseUrlImage = 'http://182.93.94.210:8000';

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
        ref.invalidate(eventProvider);
      } else if (!hasConnection) {
        wasOffline = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'No Internet Connection',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
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
    final event = ref.watch(ongoingEventProvider);
    final user = ref.watch(userDetailsProvider);

    return Scaffold(
      body: event.when(
        data: (event) {
          if (event.isEmpty) {
            return Center(
              child: Text('No Event Available'),
            );
          }
          final filteredEvents = event
              .where((e) =>
                  e.title
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()) ||
                  e.location
                      .toLowerCase()
                      .contains(widget.searchQuery.toLowerCase()))
              .toList();

          if (filteredEvents.isEmpty) {
            return const Center(child: Text('No events match your search.'));
          }

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.8,
              maxWidth: screenWidth,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.008,
                right: screenWidth * 0.03,
                left: screenWidth * 0.03,
              ),
              child: ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final events = filteredEvents[index];
                  return Card(
                    color: Colors.white,
                    shadowColor: Colors.grey.withAlpha(10),
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(
                          width: 0,
                          style: BorderStyle.solid,
                          color: Colors.grey),
                    ),
                    clipBehavior: Clip.antiAlias,
                    elevation: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Image
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
                          child: (events.poster != null &&
                                  events.poster!.isNotEmpty)
                              ? Image.network(
                                  '$baseUrlImage${events.poster}',
                                  // height: screenHeight * 0.2,
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 6),
                              // Title
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FittedBox(
                                    child: Text(
                                      events.title,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                          fontSize: 18,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              // Date and Location row
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              width: 6,
                                              color: Color(0xffF4F5FC)),
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
                                                    '${formatDateManually(DateTime.parse(events.startDate))}-${formatDateManually(DateTime.parse(events.endDate))}',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    formatDateManually(
                                                      DateTime.parse(
                                                          events.endDate),
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
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              width: 6,
                                              color: Color(0xffF9F2F3)),
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
                                                      Icons
                                                          .location_on_outlined,
                                                      color:
                                                          // Color(0xffF77018)
                                                          Color(0xffe92429),
                                                    ),
                                                  ),
                                                  SizedBox(width: 7),
                                                  Text(
                                                    'Location',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          // Color(0xffF77018)
                                                          Color(0xffe92429),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                events.location,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 18),
                              // Conditional Buttons based on User Role
                              user.when(
                                data: (userData) {
                                  if (userData.role == 'user') {
                                    return ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EntryForm(eventData: events),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff0a519d),
                                        minimumSize: Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                    );
                                  } else if (userData.role == 'organization') {
                                    if (events.hasStalls) {
                                      return ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => StallPage(
                                                eventId:
                                                    events.eventId.toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff667EEA),
                                          minimumSize:
                                              Size(double.infinity, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 26, vertical: 0),
                                        ),
                                        child: Text(
                                          'BOOK STALL',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Text(
                                          'No stalls available',
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  return SizedBox
                                      .shrink(); // Fallback for unknown roles
                                },
                                loading: () => SizedBox.shrink(),
                                error: (error, stackTrace) => SizedBox.shrink(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
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
        ),
      ),
    );
  }
}
