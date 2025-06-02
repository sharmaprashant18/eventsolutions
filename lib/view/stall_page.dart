import 'package:eventsolutions/model/stall_model.dart';
import 'package:eventsolutions/provider/stall_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StallPage extends ConsumerStatefulWidget {
  const StallPage({super.key});

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

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 12, 31),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final stalls = ref.watch(stallProvider);

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
                  top: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _showDatePicker(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.04,
                                  vertical: screenHeight * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  spacing: 10,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      formattedDate,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Icon(Icons.keyboard_arrow_down_outlined,
                                        color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _showTimePicker(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.06,
                                  vertical: screenHeight * 0.015,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  spacing: 10,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      formattedTime,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Icon(Icons.keyboard_arrow_down_outlined,
                                        color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Text(
                      'Select  stall',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    SizedBox(height: screenHeight * 0.03),
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
                              'Selected',
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
                              'Reserved',
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
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Icon(Icons.check_circle,
                                color: Colors.green, size: 40),
                            content: const Text(
                              'Your stall has been confirmed!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xFF2D5A5A)),
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D5A5A),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.3,
                      vertical: screenHeight * 0.015,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Confirm Stall',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )
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

  Widget gridViewItem(BuildContext context, List<StallModel> stalls) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return SizedBox(
        height: screenHeight * 0.4,
        child: Row(
          children: [
            Expanded(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 7,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.9,
                ),
                itemCount: stalls.length,
                itemBuilder: (context, index) {
                  final stall = stalls[index];
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
                      // setState(() {
                      //   //on tap logic here
                      // });
                      if (stall.status.toLowerCase() != 'available') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'This stall is ${stall.status.toLowerCase()}',
                            ),
                          ),
                        );
                        setState(() {});
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
                      child: stalls[index].name.isNotEmpty
                          ? Center(
                              child: Text(
                                stalls[index].name,
                                style: TextStyle(
                                  color: color == Colors.white
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: screenWidth * 0.09),
          ],
        ));
  }
}
