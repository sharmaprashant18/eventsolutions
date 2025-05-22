import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OngoingEvents extends ConsumerWidget {
  const OngoingEvents({super.key});

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
    return Container(
      color: const Color(0xffF4F4F4),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          ongoingEvents(context, 'assets/user1.jpeg', 'Designers Meetup 2022',
              '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
          ongoingEvents(context, 'assets/user2.png', 'Designers Meetup 2022',
              '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
          ongoingEvents(context, 'assets/user3.jpeg', 'Designers Meetup 2022',
              '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
          ongoingEvents(context, 'assets/image.png', 'Designers Meetup 2022',
              '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
          ongoingEvents(context, 'assets/user4.jpg', 'Designers Meetup 2022',
              '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
          ongoingEvents(context, 'assets/user5.jpg', 'Designers Meetup 2022',
              '03 October, 22', 'Kathmandu, Nepal', '\$10 USD'),
        ],
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
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 25),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.transparent)),
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
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
                              shape: BoxShape.circle, color: Colors.orange),
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
            VerticalDivider(
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
                  onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
