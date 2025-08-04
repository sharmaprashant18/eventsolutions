// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminChanging extends ConsumerStatefulWidget {
  const AdminChanging({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminChangingState();
}

class _AdminChangingState extends ConsumerState<AdminChanging> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final baseUrlImage = 'http://182.93.94.210:8001';

//current index of the the dropdown list
  String _selectedEventType = 'Music';
  //list of the events
  final List<String> _eventTypes = [
    'Music',
    'Sports',
    'Tech',
    'Art',
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: Color(0xffFBFBFB),
      body: Padding(
        padding: EdgeInsets.only(
            right: screenWidth * 0.05,
            left: screenWidth * 0.05,
            top: screenHeight * 0.07,
            bottom: screenHeight * 0.01),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  'assets/event1.png',
                  height: screenHeight * 0.2,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    eventPhotos('assets/event2.png'),
                    eventPhotos('assets/event3.png'),
                    eventPhotos('assets/event4.png'),
                    CustomPaint(
                      painter: DottedBorderPainter(),
                      child: Container(
                        width: 70,
                        height: 75,
                        alignment: Alignment.center,
                        child: Icon(Icons.add, color: Colors.orange),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                      Colors.black,
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.2, 0.7, 1],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Container(
                  height: 0.5,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.03,
              ),
              Text(
                'Event Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: screenHeight * 0.017,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelWithEditIcon('Event Name'),
                    SizedBox(height: screenHeight * 0.008),
                    textformField('widget.events.title',
                        controller: _eventNameController),
                    SizedBox(height: screenHeight * 0.015),
                    labelWithEditIcon('Event Type'),
                    SizedBox(height: screenHeight * 0.008),
                    dropdownField(),
                    SizedBox(height: screenHeight * 0.015),
                    labelWithEditIcon('Start Date'),
                    SizedBox(height: screenHeight * 0.008),
                    dateTimeField(context),
                    SizedBox(height: screenHeight * 0.015),
                    labelWithEditIcon('Event Description'),
                    SizedBox(height: screenHeight * 0.008),
                    textformField(
                      'This is a event which is organizing in Kathmandu Nepal',
                      controller: _descriptionController,
                      maxLines: 4,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'SAVE CHANGES',
                          style:
                              TextStyle(letterSpacing: 1, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget eventPhotos(String image) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            image,
            width: 85,
            height: 78,
            fit: BoxFit.fitHeight,
          ),
        ),
        SizedBox(width: 15)
      ],
    );
  }

  Widget textformField(String text,
      {TextEditingController? controller, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey)),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey)),
      ),
    );
  }

  Widget dropdownField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedEventType,
        items: _eventTypes
            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => _selectedEventType = value);
          }
        },
        decoration: InputDecoration(border: InputBorder.none),
      ),
    );
  }

  Widget dateTimeField(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: now,
          firstDate: now,
          lastDate: DateTime(now.year + 5),
        );
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) {
            _dateController.text =
                '${time.format(context)}, ${date.day} ${_monthName(date.month)} ${date.year}';
            setState(() {});
          }
        }
      },
      child: AbsorbPointer(
        child: textformField('widget.events.startDate',
            controller: _dateController),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  Widget labelWithEditIcon(String label) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

//Custom Paint for the dotted container
class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final radius = 12.0;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(radius),
      ));

    final dashWidth = 6.0;
    final dashSpace = 3.0;
    double distance = 0.0;

    final PathMetrics metrics = path.computeMetrics();
    for (final metric in metrics) {
      while (distance < metric.length) {
        final extractPath = metric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
