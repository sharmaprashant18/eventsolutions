import 'dart:developer';

import 'package:eventsolutions/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class OurTeamPage extends ConsumerStatefulWidget {
  const OurTeamPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OurTeamPageState();
}

class _OurTeamPageState extends ConsumerState<OurTeamPage> {
  @override
  Widget build(BuildContext context) {
    final teamMembers = ref.watch(teamProvider);
    final baseUrlImage = 'http://182.93.94.210:8001';
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
            top: screenHeight * 0.08,
            right: screenWidth * 0.05,
            left: screenWidth * 0.05),
        child: Column(
          children: [
            Text(
              'Our team',
              style: TextStyle(
                  fontSize: 25,
                  color: Color(0xffe92429),
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            Text(
              '''Our team believes in working as a team to achieve the greatest outcomes, and their professional expertise working in this industry for many years has set our own benchmark with the best client ratings. We have established a benchmark in the exhibition planning, helping the corporate sector to reach new heights.''',
              style: TextStyle(fontWeight: FontWeight.w400, letterSpacing: 1.2),
            ),
            Expanded(
              child: teamMembers.when(
                  data: (teamData) {
                    if (teamData.isEmpty) {
                      return Center(
                        child: Text('No Team Members'),
                      );
                    }
                    return PageView(
                      children: [
                        ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: teamData.length,
                          itemBuilder: (context, index) {
                            final team = teamData[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Image.network(
                                    '$baseUrlImage${team.photo}',
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: 200,
                                      width: 200,
                                      color: Colors.grey.shade300,
                                      child: Center(
                                        child: Icon(Icons.broken_image,
                                            size: 48, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  team.name.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(team.department),
                                // Text(team.socialLinks.facebook ?? '')

                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        launchUrl(Uri.parse(
                                            team.socialLinks.facebook ??
                                                'N/A'));
                                        log("Facebook link tapped");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xff0a519d)
                                                  .withAlpha(25),
                                            )),
                                        child: ClipOval(
                                          child: Icon(
                                            Icons.facebook,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        launchUrl(Uri.parse(
                                            team.socialLinks.facebook ??
                                                'N/A'));
                                        log("Facebook link tapped");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Color(0xff0a519d)
                                                  .withAlpha(25),
                                            )),
                                        child: ClipOval(
                                          child: Icon(
                                            Icons.facebook,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text('Failed to get the team member:$error'),
                    );
                  },
                  loading: () => Center(
                        child: CircularProgressIndicator(),
                      )),
            ),
          ],
        ),
      ),
    );
  }
}
