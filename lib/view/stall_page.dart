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
  final Set<String> selectedStallIds = <String>{};
  bool isMultiSelectMode = false;

  @override
  void initState() {
    super.initState();
    selectedStallIds.clear();
  }

  String get formattedDate {
    final selectedDate = DateTime.now();
    return "${selectedDate.day.toString().padLeft(2, '0')} "
        "${_monthName(selectedDate.month)}, "
        "${selectedDate.year}";
  }

  String get formattedTime {
    final selectedTime = TimeOfDay.now();
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

  void _showActionDialog(BuildContext context, List<String> stallIds,
      {bool isSingleTap = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isSingleTap
              ? 'Choose Action'
              : 'Choose Action for ${stallIds.length} Stall(s)'),
          content: Text(isSingleTap
              ? 'Do you want to hold or book this stall?'
              : 'Do you want to hold or book these stalls?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HoldStallPage(stallIds: stallIds),
                  ),
                ).then((_) {
                  setState(() {
                    selectedStallIds.clear();
                    isMultiSelectMode = false;
                  });
                  ref.invalidate(stallProvider(widget.eventId));
                });
              },
              child: const Text('Hold'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StallDetails(stallIds: stallIds),
                  ),
                ).then((_) {
                  setState(() {
                    selectedStallIds.clear();
                    isMultiSelectMode = false;
                  });
                  ref.invalidate(stallProvider(widget.eventId));
                });
              },
              child: const Text('Book'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final stalls = ref.watch(stallProvider(widget.eventId));
    const baseUrlImage = 'http://182.93.94.210:8001';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Select Stall',
          style:
              TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D5A5A)),
        ),
        actions: [
          if (isMultiSelectMode && selectedStallIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                _showActionDialog(context, selectedStallIds.toList());
              },
            ),
        ],
      ),
      body: stalls.when(
        data: (stalls) {
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
                                      color: Colors.transparent),
                                  loadingBuilder: (context, event) =>
                                      const Center(
                                          child: CircularProgressIndicator()),
                                  errorBuilder: (context, error, stackTrace) =>
                                      Column(
                                    children: [
                                      Image.asset('assets/error.png',
                                          fit: BoxFit.cover),
                                      const Text(
                                        'No Images Found',
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
                                  maxScale:
                                      PhotoViewComputedScale.covered * 6.0,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        'Select stall',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      gridViewItem(context, stalls),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.blue, shape: BoxShape.circle),
                                height: screenHeight * 0.015,
                                width: screenWidth * 0.1,
                              ),
                              const Text('Holded',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color(0xff57EB63),
                                    shape: BoxShape.circle),
                                height: screenHeight * 0.015,
                                width: screenWidth * 0.1,
                              ),
                              const Text('Booked',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                height: screenHeight * 0.015,
                                width: screenWidth * 0.1,
                              ),
                              const Text('Available',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.13),
                if (!isMultiSelectMode)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: selectedStallIds.isNotEmpty
                          ? () {
                              _showActionDialog(
                                  context, selectedStallIds.toList());
                            }
                          : null,
                      child: const Text('Proceed to Booking'),
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
                    ),
                  ),
              ],
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget gridViewItem(BuildContext context, StallData stalls) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
          color = const Color(0xff57EB63);
        } else if (stall.status == 'available') {
          color = selectedStallIds.contains(stall.stallId)
              ? Colors.yellow
              : Colors.white;
        } else {
          color = Colors.black;
        }

        return GestureDetector(
          onTap: () {
            if (stall.status == 'available') {
              if (isMultiSelectMode) {
                setState(() {
                  if (selectedStallIds.contains(stall.stallId)) {
                    selectedStallIds.remove(stall.stallId);
                    if (selectedStallIds.isEmpty) {
                      isMultiSelectMode = false;
                    }
                  } else {
                    selectedStallIds.add(stall.stallId);
                  }
                });
              } else {
                _showActionDialog(context, [stall.stallId], isSingleTap: true);
              }
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Stall Not Available'),
                    content: Text('This stall is ${stall.status}.'),
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
          onLongPress: () {
            if (stall.status == 'available') {
              setState(() {
                isMultiSelectMode = true;
                if (!selectedStallIds.contains(stall.stallId)) {
                  selectedStallIds.add(stall.stallId);
                }
              });
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300, width: 1),
            ),
            child: Center(
              child: Text(
                stall.name,
                style: TextStyle(
                  color: color == Colors.white ? Colors.black : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
