import 'package:eventsolutions/model/stall/stall_model.dart';
import 'package:eventsolutions/provider/stall_provider.dart';
import 'package:eventsolutions/view/hold_stall.dart';
import 'package:eventsolutions/view/stall_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';

class StallPage extends ConsumerStatefulWidget {
  const StallPage({super.key, required this.eventId});
  final String eventId;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StallPageState();
}

class _StallPageState extends ConsumerState<StallPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  String get formattedDate {
    return "${selectedDate.day.toString().padLeft(2, '0')} "
        "${_monthName(selectedDate.month)}, "
        "${selectedDate.year}";
  }

  String get formattedTime {
    return "${selectedTime.hour.toString().padLeft(2, '0')}:"
        "${selectedTime.minute.toString().padLeft(2, '0')} ${_amPm(selectedTime.hour)}";
  }

  String _amPm(int hour) {
    return hour >= 12 ? 'PM' : 'AM';
  }

  String _monthName(int month) {
    const months = [
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
    return months[month - 1];
  }

  // Future<void> _showDatePicker(BuildContext context) async {
  //   final DateTime? pickedDate = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2026, 12, 31),
  //   );
  //   if (pickedDate != null) {
  //     setState(() {
  //       selectedDate = pickedDate;
  //     });
  //   }
  // }

  // Future<void> _showTimePicker(BuildContext context) async {
  //   final TimeOfDay? pickedTime = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //     initialEntryMode: TimePickerEntryMode.input,
  //     builder: (BuildContext context, Widget? child) {
  //       return MediaQuery(
  //         data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
  //         child: child!,
  //       );
  //     },
  //   );
  //   if (pickedTime != null) {
  //     setState(() {
  //       selectedTime = pickedTime;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final stalls = ref.watch(stallProvider(widget.eventId));
    final baseUrlImage = 'http://182.93.94.210:8000';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Select Stall',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D5A5A)),
        ),
      ),
      body: stalls.when(data: (stalls) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.05,
                  right: screenWidth * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: screenHeight * 0.3,
                      width: screenWidth,
                      child: PageView.builder(
                        controller: PageController(viewportFraction: 1),
                        itemCount: stalls.floorPlans.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: PhotoView(
                                imageProvider: NetworkImage(
                                    '$baseUrlImage${stalls.floorPlans[index]}'),
                                backgroundDecoration: const BoxDecoration(
                                  color: Colors.transparent,
                                ),
                                loadingBuilder: (context, event) =>
                                    const Center(
                                        child: CircularProgressIndicator()),
                                errorBuilder: (context, error, stackTrace) =>
                                    Column(
                                  children: [
                                    Image.asset('assets/error.png',
                                        fit: BoxFit.cover),
                                    const Text(
                                      'No Image Found',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                minScale:
                                    PhotoViewComputedScale.contained * 0.5,
                                maxScale: PhotoViewComputedScale.covered * 6.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),
                    //if the event has a date and time, show them
                    Text(
                      'Select  stall',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    gridViewItem(context, stalls),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue, shape: BoxShape.circle),
                              height: screenHeight * 0.015,
                              width: screenWidth * 0.1,
                            ),
                            Text(
                              'Holded',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff57EB63),
                                  shape: BoxShape.circle),
                              height: screenHeight * 0.015,
                              width: screenWidth * 0.1,
                            ),
                            Text(
                              'Booked',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white,
                                  shape: BoxShape.circle),
                              height: screenHeight * 0.015,
                              width: screenWidth * 0.1,
                            ),
                            Text(
                              'Available',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.13),
            ],
          ),
        );
      }, error: (error, stackTrace) {
        return Center(child: Text('Error: $error'));
      }, loading: () {
        return Center(child: CircularProgressIndicator());
      }),
    );
  }

  Widget gridViewItem(BuildContext context, StallData stalls) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 7,
        mainAxisSpacing: 15,
        childAspectRatio: 0.9,
      ),
      itemCount: stalls.stall.length,
      itemBuilder: (context, index) {
        final stall = stalls.stall[index];
        Color color;
        if (stall.status == 'hold') {
          color = Colors.blue;
        } else if (stall.status == 'booked') {
          color = Color(0xff57EB63);
        } else if (stall.status == 'available') {
          color = Colors.white;
        } else {
          color = Colors.black;
        }

        return GestureDetector(
          onTap: () {
            final status = stall.status.toLowerCase();

            if (status == 'available') {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Choose Action'),
                    content:
                        const Text('Do you want to hold or book this stall?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return HoldStallPage(stallId: stall.stallId);
                          }));
                        },
                        child: const Text('Hold'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StallDetails(stallId: stall.stallId),
                            ),
                          );
                        },
                        child: const Text('Book'),
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Stall Not Available'),
                    content: Text('This stall is $status.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: stall.name.isNotEmpty
                ? Center(
                    child: Text(
                      stall.name,
                      style: TextStyle(
                        color:
                            color == Colors.white ? Colors.black : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}



  // Row(
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           'Date',
                    //           style: TextStyle(fontWeight: FontWeight.bold),
                    //         ),
                    //         const SizedBox(height: 8)Color.fromARGB(255, 98, 36, 32)             //         GestureDetector(
                    //           onTap: () => _showDatePicker(context),
                    //           child: Container(
                    //             padding: EdgeInsets.symmetric(
                    //               horizontal: screenWidth * 0.04,
                    //               vertical: screenHeight * 0.015,
                    //             ),
                    //             decoration: BoxDecoration(
                    //               border: Border.all(color: Colors.grey),
                    //               borderRadius: BorderRadius.circular(15),
                    //             ),
                    //             child: Row(
                    //               spacing: 10,
                    //               mainAxisSize: MainAxisSize.min,
                    //               children: [
                    //                 Text(
                    //                   formattedDate,
                    //                   style: TextStyle(color: Colors.grey),
                    //                 ),
                    //                 Icon(Icons.keyboard_arrow_down_outlined,
                    //                     color: Colors.grey),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     Spacer(),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           'Time',
                    //           style: TextStyle(fontWeight: FontWeight.bold),
                    //         ),
                    //         const SizedBox(height: 8),
                    //         GestureDetector(
                    //           onTap: () => _showTimePicker(context),
                    //           child: Container(
                    //             padding: EdgeInsets.symmetric(
                    //               horizontal: screenWidth * 0.06,
                    //               vertical: screenHeight * 0.015,
                    //             ),
                    //             decoration: BoxDecoration(
                    //               border: Border.all(color: Colors.grey),
                    //               borderRadius: BorderRadius.circular(15),
                    //             ),
                    //             child: Row(
                    //               spacing: 10,
                    //               mainAxisSize: MainAxisSize.min,
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceEvenly,
                    //               children: [
                    //                 Text(
                    //                   formattedTime,
                    //                   style: TextStyle(color: Colors.grey),
                    //                 ),
                    //                 Icon(Icons.keyboard_arrow_down_outlined,
                    //                     color: Colors.grey),
                    //               ],
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: screenHeight * 0.05),