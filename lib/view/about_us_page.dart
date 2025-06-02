import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutUsPage extends ConsumerWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;

    final screenHeight = screenSize.height;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Text(
            'About the Company',
            style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                wordSpacing: 2),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(right: 15, left: 15, bottom: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '''
Event Solution Pvt. Ltd., founded in 2014, is a constructive and highly dedicated organization founded with the goal of managing and arranging various events in various fields. The name says it all: Event Solution is a firm that aims to deliver the best solutions for all of your events, making event planning a stress-free.

We have hundreds of clients ranging from major corporations to global brands, and we have successfully designed, coordinated, and executed large-scale events. Our caring team of experts helps your vision become a reality and adds fascinating insights to your thoughts; furthermore we also provide rental services, creative desiging servies, event counseling and all other necessary required services in for a successful event.

Our team believes in working as a team to achieve the greatest outcomes, and their professional expertise working in this industry for many years has set our own benchmark with the best client ratings. We have established a benchmark in the exhibition planning, helping the corporate sector to reach new heights.''',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: Text(
                        'Our Approach',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            wordSpacing: 2),
                      )),
                      SizedBox(
                        height: 15,
                      ),
                      buildCard(context, 'LEARN & PLAN',
                          '''We learn about your business, challenges, demand and your requirement the way you want your event to be like. We study and analyze all twists and turns and go forward for the best, so the first step for us is about what you actually want your event to be.'''),
                      SizedBox(
                        height: 15,
                      ),
                      buildCard(context, 'BUILD & TARGET',
                          '''Let us look after the details and the heavy lifting that comes with planning a professional event. From our network of preferred vendors, we can deliver a full service.'''),
                      SizedBox(
                        height: 15,
                      ),
                      buildCard(context, 'EXECUTION & DELIVER',
                          '''Finally, this is where our event management expertise comes into execution.From meticulous management of facility details ato AV, catering and onsite coordination, we ensure every detail is looked after.''')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildCard(BuildContext context, String title, String subtitle) {
    // final screenSize = MediaQuery.of(context).size;
    // final screenWidth = screenSize.width;
    return Container(
      decoration: BoxDecoration(
          // color: Colors.blueGrey,
          color: Colors.green[700],
          borderRadius: BorderRadius.only(
              // topLeft: Radius.circular(15),
              topLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20))),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                title,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              subtitle,
              style: TextStyle(
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
