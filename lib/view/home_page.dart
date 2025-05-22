import 'package:eventsolutions/services/auth_service.dart';
import 'package:eventsolutions/view/about_us_page.dart';
import 'package:eventsolutions/view/contact_us_page.dart';
import 'package:eventsolutions/view/upcoming.dart';
import 'package:eventsolutions/view/faq.dart';
import 'package:eventsolutions/view/loginpage.dart';
import 'package:eventsolutions/view/on_going.dart';
import 'package:eventsolutions/view/privacypolicy.dart';
import 'package:eventsolutions/view/service_page.dart';
import 'package:eventsolutions/view/stall_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: screenHeight * 0.2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black, BlendMode.colorDodge),
                      image: AssetImage('assets/event_solutions.png'))),
              padding: EdgeInsets.only(top: 100, bottom: 20),
            ),
            SizedBox(
              height: 10,
            ),
            _drawer(
                context,
                6,
                'Our Services',
                Icon(
                  Icons.miscellaneous_services_rounded,
                  color: Color(0xff5F73F3),
                  size: 25,
                )),
            _drawer(
                context,
                5,
                'Stall',
                Icon(
                  Icons.shop,
                  color: Color(0xff5F73F3),
                  size: 25,
                )),
            _drawer(
                context,
                0,
                'About Us',
                Icon(
                  Icons.info,
                  color: Color(0xff5F73F3),
                  size: 25,
                )),
            _drawer(
                context,
                1,
                'Contact Us',
                Icon(
                  Icons.contact_page,
                  color: Color(0xff5F73F3),
                  size: 25,
                )),
            _drawer(
                context,
                2,
                'Privacy Policy',
                Icon(
                  Icons.play_lesson,
                  color: Color(0xff5F73F3),
                  size: 25,
                )),
            _drawer(
                context,
                3,
                'FAQ',
                Icon(
                  Icons.support_agent,
                  color: Color(0xff5F73F3),
                  size: 25,
                )),
            _drawer(
                context,
                4,
                'Log Out',
                Icon(
                  Icons.logout,
                  color: Color(0xff5F73F3),
                  size: 25,
                )),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.08,
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
        title: Text(
          'Events',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 10, left: 10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Container(
                height: screenHeight * 0.06,
                width: double.infinity,
                decoration: BoxDecoration(
                    // color: Color(0xffF6F6F6),
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20)),
                child: TabBar(
                    tabAlignment: TabAlignment.fill,
                    // isScrollable: true,
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    // labelColor: Color(0xffF77018),
                    labelColor: Colors.deepOrange,
                    unselectedLabelColor: Colors.grey,
                    padding: EdgeInsets.all(9),
                    labelStyle:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    unselectedLabelStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withAlpha(20),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                        color: Colors.white),
                    tabs: [
                      Tab(text: 'SERVICES'),
                      Tab(
                        text: 'ONGOING',
                      ),
                      Tab(text: 'UPCOMING'),
                    ]),
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: [ServicePage(), OngoingEvents(), UpcomingPage()]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context, int id, String title, Icon icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        title: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 6),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              switch (id) {
                case 0:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutUsPage()));
                  break;
              }
              switch (id) {
                case 1:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ContactUsPage()));
                  break;
              }
              switch (id) {
                case 2:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Privacypolicy()));
                  break;
              }
              switch (id) {
                case 3:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FaqPage()));
                  break;
              }
              switch (id) {
                case 4:
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Logout"),
                        content: Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            child: Text(
                              "No",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              "Yes",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              AuthService().logout();
                              Navigator.of(context).pop();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (Route<dynamic> route) => false,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                  break;
              }

              switch (id) {
                case 5:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StallPage()));
                  break;
              }
              switch (id) {
                case 6:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ServicePage()));
                  break;
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon,
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )),
      ),
    );
  }
}
