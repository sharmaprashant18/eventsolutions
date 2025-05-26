import 'package:eventsolutions/services/auth_services/auth_service.dart';
import 'package:eventsolutions/view/about_us_page.dart';
import 'package:eventsolutions/view/contact_us_page.dart';
import 'package:eventsolutions/view/our_service_page.dart';
import 'package:eventsolutions/view/ticket_qr.dart';
import 'package:eventsolutions/view/ongoing_events.dart';
import 'package:eventsolutions/view/faq.dart';
import 'package:eventsolutions/view/loginpage.dart';
import 'package:eventsolutions/view/privacypolicy.dart';
import 'package:eventsolutions/view/stall_page.dart';
import 'package:eventsolutions/view/upcoming_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _lastBackPressed;

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

  // Method to handle back button press
  void _handleBackPress(bool didPop, dynamic result) {
    if (didPop) return;

    if (_tabController.index == 2) {
      _tabController.animateTo(1);
      return;
    } else if (_tabController.index == 1) {
      _tabController.animateTo(0);
      return;
    } else if (_tabController.index == 0) {
      final now = DateTime.now();
      if (_lastBackPressed == null ||
          now.difference(_lastBackPressed!) > const Duration(seconds: 1)) {
        _lastBackPressed = now;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      SystemNavigator.pop();
    }
  }

  bool get _canPop {
    if (_tabController.index != 0) return false;

    final now = DateTime.now();
    if (_lastBackPressed == null ||
        now.difference(_lastBackPressed!) > const Duration(seconds: 1)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;

    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: _handleBackPress,
      child: Scaffold(
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
                    image: const AssetImage('assets/event_solutions.png'),
                  ),
                ),
                padding: const EdgeInsets.only(top: 100, bottom: 20),
              ),
              const SizedBox(height: 10),
              _drawer(
                context,
                6,
                'Our Services',
                const Icon(
                  Icons.miscellaneous_services_rounded,
                  color: Color(0xff5F73F3),
                  size: 25,
                ),
              ),
              _drawer(
                context,
                5,
                'Stall',
                const Icon(
                  Icons.shop,
                  color: Color(0xff5F73F3),
                  size: 25,
                ),
              ),
              _drawer(
                context,
                0,
                'About Us',
                const Icon(
                  Icons.info,
                  color: Color(0xff5F73F3),
                  size: 25,
                ),
              ),
              _drawer(
                context,
                1,
                'Contact Us',
                const Icon(
                  Icons.contact_page,
                  color: Color(0xff5F73F3),
                  size: 25,
                ),
              ),
              _drawer(
                context,
                2,
                'Privacy Policy',
                const Icon(
                  Icons.play_lesson,
                  color: Color(0xff5F73F3),
                  size: 25,
                ),
              ),
              _drawer(
                context,
                3,
                'FAQ',
                const Icon(
                  Icons.support_agent,
                  color: Color(0xff5F73F3),
                  size: 25,
                ),
              ),
              _drawer(
                context,
                4,
                'Log Out',
                const Icon(
                  Icons.logout,
                  color: Color(0xff5F73F3),
                  size: 25,
                ),
              ),
              _drawer(
                context,
                7,
                'Ticket',
                const Icon(
                  Icons.local_activity,
                  color: Color(0xff5F73F3),
                  size: 25,
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          toolbarHeight: screenHeight * 0.08,
          centerTitle: true,
          elevation: 1,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
          title: const Text(
            'Events',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Container(
                  height: screenHeight * 0.06,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TabBar(
                    tabAlignment: TabAlignment.fill,
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.deepOrange,
                    unselectedLabelColor: Colors.grey,
                    padding: const EdgeInsets.all(9),
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    unselectedLabelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
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
                      color: Colors.white,
                    ),
                    tabs: const [
                      Tab(text: 'ONGOING'),
                      Tab(text: 'UPCOMING'),
                      Tab(text: 'SERVICES'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    OngoingEvents(),
                    UpcomingEvents(),
                    ServicePage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context, int id, String title, Icon icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 6),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            switch (id) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutUsPage()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactUsPage()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Privacypolicy()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FaqPage()),
                );
                break;
              case 4:
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          child: const Text(
                            "No",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            "Yes",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            AuthService().logout();
                            Navigator.of(context).pop();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (Route<dynamic> route) => false,
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
                break;
              case 5:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const StallPage()),
                );
                break;
              case 6:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ServicePage()),
                );
                break;
              case 7:
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TicketQr(ticketId: null)));
                break;
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
